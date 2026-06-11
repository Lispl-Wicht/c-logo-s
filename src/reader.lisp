(in-package #:logo)

;;;; ======================================================================
;;;;
;;;;                        Surface normalization
;;;;
;;;; ======================================================================

;; The normalizer must partition the input stream into disjoint, immutable
;; syntactic regions (:NORMAL, :BAR, :COMMENT) such that no region contains
;; unresolved cross-region syntax dependencies, and no later stage is
;; required to interpret raw character relationships across region boundaries.

;; Guarantee: A raw character stream becomes a sequence of syntactic
;; islands where no island can corrupt another’s interpretation.

;; :COMMENT segments are never reprocessed by any later stage
;; :BAR segments must be one-liners.
;; :NORMAL = cleaned surface, code with only the following guarantees:
;;           - no line continuation+NL artefacts
;;           - no comment syntax
;;           - no bar literals
;;           - no whitespace noise
;;           BUT it still contains:
;;               - operators
;;               - identifiers
;;               - syntax structure
;;               - malformed constructs

(defun continue-lines (in-str)
  "Removes Berkeley Logo line continuations in IN-STR: a tilde (~) followed by optional spaces/tabs and a newline."
  (with-output-to-string (out-str)
    (loop :for i :from 0 :below (length in-str)
          :for ch := (aref in-str i)
          :do (if (and (char= ch #\~)
                       (< i (1- (length in-str))))
                  (let ((j (1+ i)))
                    ;; skip spaces/tabs after tilde
                    (loop :while (and (< j (length in-str))
                                      (or (char= (aref in-str j) #\Space)
                                          (char= (aref in-str j) #\Tab)))
                          :do (incf j))
                    ;; if newline follows, splice
                    (if (and (< j (length in-str))
                             (char= (aref in-str j) #\Newline))
                        (setf i j)      ; skip tilde + whitespace + newline
                        (write-char ch out-str)))
                  (write-char ch out-str)))))

(defun construct-lines (in-str)
  (let ((buf (make-string-output-stream))
        (out '()))
    (labels ((flush ()
               (push (list :line
                           (get-output-stream-string buf))
                     out)
               (setf buf (make-string-output-stream))))
      (loop :for ch :across in-str
            :do (if (char= ch #\Newline)
                    (flush)
                    (write-char ch buf)))
      ;; flush final line
      (flush)
      (nreverse out))))

(defun split-comment-in-line (line)
  (destructuring-bind (type text)
      line
      (declare (ignore type))
    (let ((pos (position #\; text)))
      (if pos
          (list :line
                (subseq text 0 pos)
                :comment (subseq text (1+ pos)))
          (list :line text
                :comment nil)))))

#|(defun preserve-comments (lines)
  (mapcar #'split-comment-in-line lines))

(defun split-bars-in-line (line)
  (destructuring-bind (type text &optional comment-mark comment-text)
      line
    (declare (ignore type))

    (let ((state :outside)
          (buf (make-string-output-stream))
          (out '()))

      (labels ((flush-normal ()
                 (let ((s (get-output-stream-string buf)))
                   (unless (string= s "")
                     (push (list :text s) out)))
                 (setf buf (make-string-output-stream))))

        (loop for ch across text do
              (ecase state

                (:outside
                 (if (char= ch #\|)
                     (progn
                       (flush-normal)
                       (setf state :inside))
                     (write-char ch buf)))

                (:inside
                 (if (char= ch #\|)
                     (progn
                       ;; HERE is the fix:
                       (push (list :barred-word
                                   (get-output-stream-string buf))
                             out)
                       (setf buf (make-string-output-stream))
                       (setf state :outside))
                     (write-char ch buf)))))

        ;; flush remainder
        (if (eq state :inside)
            (push (list :barred-word (get-output-stream-string buf)) out)
            (flush-normal))

        (append (list :line (nreverse out))
                (when comment-mark
                  (list :comment comment-text)))))))|#


;;;; ======================================================================
;;;;
;;;;                             Lexer/Parser
;;;;
;;;; ======================================================================

;;; Tokens:
;;; :name ; evaluable identifier -- foo, var, |a strange name|  
;;; :quote-name ; quoted datum (includes numebers) -- "show, "foo, "|a b|, "3, 3
;;; :thing ; :name indiretion -- :foo
;;; :infix ; operators +, -, *, × (u+00d7), ⋅ (u+22c5), /, ÷ (u+00f7), ^,
;;;           =, <, >, <=, ≤ (u+2264), >=, ≥ (u+2265),
;;;           ← (u+2190)
;;; :obracket, :obrace, :oparen -- [, {, ( ; structural items
;;; :cbracket, :cbrace, :cparen -- ], }, ) ; structural items
;;; :whitespace
;;; :eof

;; 1st step: Lexical segmentation

(defun whitespace-char-p (ch)
  (member ch '(#\Space #\Tab #\Newline) :test #'char=))

(defun structural-char-p (ch)
  (member ch '(#\[ #\{ #\( #\] #\} #\)) :test #'char=))

(defun infix-char-p (ch)
  (member ch '(#\+ #\- #\* #\/ #\^
               #\= #\< #\>
               #\× #\÷ #\⋅ #\≤ #\≥
               #\←)
          :test #'char=))

(defun delimiter-char-p (ch)
  (or (whitespace-char-p ch)
      (structural-char-p ch)
      (infix-char-p ch)))


(defun tokenize-normal (in-str)
  "Tokenize a line string into lexical tokens (NO BAR logic here)."

  (let ((i 0)
        (len (length in-str))
        (pushback nil)
        (state :start)
        (buf (make-string-output-stream))
        (tokens '()))

    (labels
        ((next-char ()
           (if pushback
               (prog1 pushback
                 (setf pushback nil))
               (when (< i len)
                 (prog1 (char in-str i)
                   (incf i)))))

         (emit (type &optional barred)
           (if (and (eq :quote-name type)
                       (not barred))
               (push (list type (get-output-stream-string buf) :barred nil) tokens)
               (push (list type (get-output-stream-string buf)) tokens))
            (setf buf (make-string-output-stream)))

         (emit-char (type ch)
           (push (list type (string ch)) tokens))

         (flush-name ()
           (emit :name)
           (setf state :start))

         (flush-quote-name (&optional barred)
           (emit :quote-name barred)
           (setf state :start))

         (flush-thing ()
           (emit :thing)
           (setf state :start)))

      (loop for ch = (next-char)
            while ch do
              (ecase state

                (:start
                 (cond
                   ((whitespace-char-p ch)
                    (emit-char :whitespace ch))

                   ((char= ch #\")
                    (setf state :in-quote-name))

                   ((char= ch #\:)
                    (setf state :in-thing))

                   ((structural-char-p ch)
                    (emit-char
                     (ecase ch
                       (#\[ :obracket)
                       (#\] :cbracket)
                       (#\( :oparen)
                       (#\) :cparen)
                       (#\{ :obrace)
                       (#\} :cbrace))
                     ch))

                   ((infix-char-p ch)
                    (emit-char :infix ch))

                   (t
                    (write-char ch buf)
                    (setf state :in-name))))

                (:in-name
                 (if (delimiter-char-p ch)
                     (progn (flush-name) (setf pushback ch))
                     (write-char ch buf)))

                (:in-quote-name
                 (if (delimiter-char-p ch)
                     (progn (flush-quote-name) (setf pushback ch))
                     (write-char ch buf)))

                (:in-thing
                 (if (delimiter-char-p ch)
                     (progn (flush-thing) (setf pushback ch))
                     (write-char ch buf)))))

      (ecase state
        (:start nil)
        (:in-name (flush-name))
        (:in-quote-name (flush-quote-name))
        (:in-thing (flush-thing)))

      (nreverse tokens))))

(defun tokenize-segments (segments)
  "Tokenize a list of (:LINE ...) segments into a full token stream."

  (list :tokens
        (mapcar (lambda (seg)
                  (destructuring-bind (type content &rest meta)
                      seg
                    (declare (ignore type))

                    (append
                     (list :line
                           (tokenize-normal content))
                     meta)))
                segments)
        :eof t))

(defun repair-bars (token-tree)
  "Reconstruct BAR fragments inside (:LINE ...) token structures."

  (destructuring-bind (tag lines &rest meta)
      token-tree
      (declare (ignore tag))

    (labels
        ((repair-line (line)
           (destructuring-bind (line-tag tokens &rest line-meta)
               line
             (declare (ignore line-tag))

             (let ((out '())
                   (acc "")
                   (in-bar nil))

               (labels ((flush-bar ()
                          (when (> (length acc) 0)
                            (push (list :quote-name acc :barred t) out))
                          (setf acc "")))

                 (dolist (tok tokens)
                   (destructuring-bind (type value &rest tok-meta)
                       tok

                     (cond
                       ;; BAR start detection
                       ((and (eq type :quote-name)
                             (search "|" value)
                             (not in-bar))
                        (setf in-bar t
                              acc (str:trim value
                                            :char-bag "|")))

                       ;; inside BAR accumulation
                       (in-bar
                        (setf acc (str:trim (concatenate 'string acc value)
                                            :char-bag "|") )

                        (when (search "|" value :from-end t)
                          (flush-bar)
                          (setf in-bar nil)))

                       ;; normal token (metadata preserved)
                       (t
                        (push (append (list type value) tok-meta)
                              out)))))

                 ;; safety flush
                 (when in-bar
                   (push (list :quote-name acc :barred t) out))

                 ;; rebuild LINE (metadata preserved!)
                 (append (list :line (nreverse out))
                         line-meta))))))

      (append (list :tokens
                    (mapcar #'repair-line lines))
              meta))))

;; 2nd step: Verbalization is lexical enrichment
;;           = selective semantic lifting over lexical atoms
;;
;;           first semantic commitment:
;;                 :names become plain wd-structures

(defun normalize-minus (tokens)
  "Resolve '-' into either unary MINUS (procedure word)
   or leave it as infix '-' for later infix processing."
  (labels
      (;; --- helpers -------------------------------------------------
       (infix-minus-p (tok)
         (and (consp tok)
              (eq (first tok) :infix)
              (string= (second tok) "-")))

       (value-token-p (tok)
         (and (consp tok)
              (or (and (member (first tok) '(:name :quote-name))
                       (numeric-literal-p (second tok)))
                  (eq (first tok) :thing))))

       (expression-end-p (tok-or-wd)
         (cond (;; lexical values
                (value-token-p tok-or-wd) t)

               ;; closing delimiters
               ((member (first tok-or-wd)
                        '(:cparen :cbracket :cbrace)) t)

               ;;((procedure-candidate-p tok-or-wd) t)

               ;; otherwise
               (t nil)))

       (previous-significant-token (tokens pos)
         (loop :for i :downfrom (1- pos) :to 0
               :for tok := (nth i tokens)

               :unless (eq (first tok) :whitespace)
               :do (return tok)))

       (unary-minus-p (tokens pos)
         (let ((prev (previous-significant-token tokens pos)))
           (not (and prev
                     (expression-end-p prev)))))

       (make-minus-wd ()
         (make-wd :str "minus"
                  :nmb nil
                  :sym 'logo:minus
                  :flags nil)))

    ;; --- main pass --------------------------------------------------
    (loop for tok in tokens
          for pos from 0
          collect
          (if (and (infix-minus-p tok)
                   (unary-minus-p tokens pos))
              (make-minus-wd)
              tok))))

(defun normalize-line (line)
  (destructuring-bind (tag tokens &rest meta) line
    (list* tag
           (normalize-minus tokens)
           meta)))

(defun normalize-minus-in-tree (token-tree)
  (destructuring-bind (tag lines &rest meta) token-tree
    (list* tag
           (mapcar #'normalize-line lines)
           meta)))

(defun verbalize-token (tok)
  (labels ((word-token-p (type)
             (member type '(:name :thing :quote-name :infix))))
    (cond
      ;; already verbalized → leave untouched
      ((wd-p tok)
       tok)

      ;; whitespace stays raw
      ((and (consp tok)
            (eq (first tok) :whitespace))
       tok)

      ;; structural tokens stay raw
      ((and (consp tok)
            (member (first tok)
                    '(:obracket :cbracket :oparen :cparen :obrace :cbrace)))
       tok)

      ;; word-producing tokens → WD
      ((and (consp tok)
            (word-token-p (first tok)))
       (destructuring-bind (type value &rest meta)
           tok
         (let ((barred (getf meta :barred))
               (wd (logo-wd value)))
           (case type
             (:thing (enrich-word wd :thing t :barred barred))
             (:quote-name (enrich-word wd :quoted t :barred barred))
             (:infix (enrich-word wd :infix t))
             (t wd)))))

      ;; fallback
      (t tok))))

(defun verbalize-line (line)
  (destructuring-bind (tag tokens &rest meta) line
    (append
     (list tag
           (mapcar #'verbalize-token tokens))
     meta)))

(defun verbalize-lines (token-tree)
  "Convert all word-producing tokens into WD structures."
  
  (destructuring-bind (tag lines &rest meta)
      token-tree
    (list* tag
           (mapcar #'verbalize-line lines)
           meta)))

;; Convenience knowledge:
;;   Infix operators are first-class semantic objects:
;;   syntax operator descriptors that reorganise their surrounding
;;   syntactical structure.
;;
;;   They are no procedures on their own.
;;   They are replaced with their prefix procedures
;;   in prefix position once their operands are determined.
;;
;;   Precedence:
;;     ^        100
;;     * /       80
;;     + -       60
;;     < > =     40
;;     ←         20 


(defun define-infix (&key sign (weight 0) procedure)
  (let* ((name (proc-name procedure))
         (source (gloss-place procedure :source))
         (help-wd (enrich-word (logo-wd (gloss-place name :help-text))
                               :barred t) )
         (evaluation-model (gloss-place name :evaluation-model))
         (kind (gloss-place name :kind)))
    (setf (gethash sign *glossary-table*)
          (build-gloss-from-definition sign
                                       source
                                       :help-text-wd help-wd 
                                       :evaluation-model evaluation-model
                                       :kind kind))
    
    (setf (gethash sign *infix-table*)
          (make-infix :sign sign
                      :weight weight
                      :procedure procedure))))

(defun lookup-infix (sign)
  (gethash sign *infix-table*))


(define-infix :sign "^"
  :weight 100
  :procedure (lookup-procedure "power"))

(define-infix :sign "*"
  :weight 80
  :procedure (lookup-procedure "product"))

(define-infix :sign "×"
  :weight 80
  :procedure (lookup-procedure "product"))

(define-infix :sign "⋅"
  :weight 80
  :procedure (lookup-procedure "product"))

(define-infix :sign "/"
  :weight 80
  :procedure (lookup-procedure "quotient"))

(define-infix :sign "÷"
  :weight 80
  :procedure (lookup-procedure "quotient"))

(define-infix :sign "+"
  :weight 60
  :procedure (lookup-procedure "sum"))

(define-infix :sign "-"
  :weight 60
  :procedure (lookup-procedure "difference"))

(define-infix :sign "<"
  :weight 40
  :procedure (lookup-procedure "lessp"))

(define-infix :sign "<"
  :weight 40
  :procedure (lookup-procedure "greaterp"))

(define-infix :sign "="
  :weight 40
  :procedure (lookup-procedure "equalp"))

(define-infix :sign "<="
  :weight 40
  :procedure (lookup-procedure "lessequalp"))

(define-infix :sign "≤"
  :weight 40
  :procedure (lookup-procedure "lessequalp"))

(define-infix :sign ">="
  :weight 40
  :procedure (lookup-procedure "greaterequalp"))

(define-infix :sign "≥"
  :weight 40
  :procedure (lookup-procedure "greaterequalp"))

;;(define-infix :sign "←"
;;  :weight 20
;;  :procedure (lookup-procedure "make"))

;; 2nd step: Parser (:call AST)

;; to be adjusted:
(defun procedure-candidate-p (tok-or-wd)
  "True if TOK-OR-WD can syntactically denote a procedure name
   in operator (prefix) position. No symbol resolution is assumed."
  (cond
    ;; -------------------------
    ;; Raw token case
    ;; -------------------------
    ((and (consp tok-or-wd)
          (member (first tok-or-wd) '(:name)))
     (let ((str (second tok-or-wd)))
       (and (not (numeric-literal-p str)))))

    ;; -------------------------
    ;; Verbalized word (WD)
    ;; -------------------------
    ((wd-p tok-or-wd)
     (and
      ;; not quoted
      (not (member :quoted (wd-flags tok-or-wd)))
      ;; not a thing reference
      (not (member :thing (wd-flags tok-or-wd)))
      ;; not numeric
      (null (wd-nmb tok-or-wd))))

    ;; -------------------------
    ;; Everything else
    ;; -------------------------
    (t nil)))

;; 3rd step: Semantic Lift (:ilist, :template etc.)



;; nth step: symbol resolution (interning)

;; resolve binding:
;; to be adjusted to the forelast output, right now it is the original version,
;; which was applied to early with first verbalization.
(defun parse-sym (str)  
  "PARSE-SYM str (auxiliary function)

Returns an interned symbol in the Logo workspace if STR is a valid Logo identifier that does not name a primitive or library procedure, otherwise NIL."
  (when (and (stringp str)
             (not (string= "" str))
             (null (parse-nmb str))
             (not (find str '("+" "-" "*" "/" "^"
                              "=" "<" ">"
                              "×" "÷" "⋅" "≤" "≥"
                              "←")
                        :test #'string=))
             (not (str:containsp " " str))
             (not (str:containsp "|" str))
             (not (str:containsp "#" str))
             (not (str:containsp ":" str)))
    (cond (;;(find (string-downcase str) +primitives+ :test #'string=)
           (gethash str *primitive-obarray*)
           (if (find (string-downcase str)
                     ;; Names shared with Common Lisp:
                     #("list" "array" "first" "last" "butfirst" "butlast" "item"
                       "sequencep" "arrayp" "print" "if")
                     :test #'string=)
               (intern (str:concat "LOGO-" (string-upcase str)) :logo)
               (intern (string-upcase str) :logo)))
          (;;(find (string-downcase str) +library-procs+ :test #'string=)
           (gethash str *library-obarray*)
           (intern (string-upcase str) :logo/library))
          (t
           (intern (string-upcase str) :logo/workspace)))))
