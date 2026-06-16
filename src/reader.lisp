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

(defun preserve-comments (lines)
  (flet ((extract-comment (text)
           (let ((pos (position #\; text)))
             (if pos
                 (values (subseq text 0 pos)
                         (subseq text (1+ pos)))
                 (values text nil)))))
    
    (mapcar (lambda (line)
              (multiple-value-bind (text comment)
                  (extract-comment (getf line :line))
                (list :line text
                      :comment comment)))
            lines)))


(defun number-lines (lines)
  (flet ((add-line-number (line number)
           (list* :line
                  (getf line :line)
                  :line-no number
                  (when (getf line :comment)
                    (list :comment (getf line :comment))))))
    (let ((n 0))
    (mapcar (lambda (line)
              (add-line-number line (incf n)))
            lines))))


;;;; ======================================================================
;;;;
;;;;                             Lexer/Parser
;;;;
;;;; ======================================================================

;;; Tokens:
;;; :name ; evaluable identifier -- foo, var, |a strange name|  
;;; :quote-name ; quoted datum (includes numbers) -- "show, "foo, "|a b|, "3, 3
;;; :thing ; :name indiretion -- :foo
;;; :infix ; operators +, -, *, × (u+00d7), ⋅ (u+22c5), /, ÷ (u+00f7), ^,
;;;           =, <, >, <=, ≤ (u+2264), >=, ≥ (u+2265),
;;;           ← (u+2190)
;;; :obracket, :obrace, :oparen -- [, {, ( ; structural items
;;; :cbracket, :cbrace, :cparen -- ], }, ) ; structural items
;;; :whitespace
;;; :eof
;;;
;;; A token is a pipeline object, classically an indivisable unit of text produced
;;; by a lexer that is intended to be consumed by later stages as *lexical atoms*.
;;;
;;; In cLogos, it is a stable, inspectable, replayable unit of surface
;;; representation that participates in later structural transformations.

;; 1st step: Lexical segmentation

(defun whitespace-char-p (ch)
  (member ch '(#\Space #\Tab #\Newline) :test #'char=))

(defun structural-char-p (ch)
  (member ch '(#\[ #\{ #\( #\] #\} #\)) :test #'char=))

(defun infix-prefix-char-p (ch)
  "Tests whether a character may start an infix operator."
  (member ch '(#\+ #\- #\* #\/ #\^
               #\= #\< #\>
               #\× #\÷ #\⋅ #\≤ #\≥
               #\←)
          :test #'char=))

(defun delimiter-char-p (ch)
  (or (whitespace-char-p ch)
      (structural-char-p ch)))


(defun read-infix-token (first-char next-char)
  "Return (VALUES TOKEN CONSUMED-P).
Prefer two-character infix operators registered in the workspace or
primitive infix tables."

  (when (and next-char
             (infix-prefix-char-p first-char))
    (let ((candidate (str:concat (string first-char)
                                 (string next-char))))
      (when (lookup-infix candidate)
        (return-from read-infix-token
          (values candidate t)))))

  ;; fallback: primitive single-character infix
  (values (string first-char) nil))

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

         (emit-infix (str)
          (push (list :infix str) tokens))

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

                   ((infix-prefix-char-p ch)
                    (let ((next (next-char)))
                      (multiple-value-bind (token consumed)
                          (read-infix-token ch next)
                        (emit-infix token)
                        (unless consumed
                          (setf pushback next)))))

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
        (mapcar
         (lambda (seg)
           (destructuring-bind (tag text &rest meta) seg
             (declare (ignore tag))
             (list* :line
                    (tokenize-normal text)
                    ;; meta
                    (list :line-meta (apply #'list meta)))))
         segments)))

(defun repair-bars (token-tree)
  "Reconstruct barred words by overriding token boundaries.

A barred word is reconstructed from the original token stream until
its closing bar is encountered. Inside a barred word, token boundaries
are treated as non-semantic."
  
  (destructuring-bind (tag lines)
      token-tree
    (declare (ignore tag))

    (labels
        ((repair-line (line)
           (destructuring-bind (line-tag tokens &rest line-meta)
               line
             (declare (ignore line-tag))

             (let ((out '())
                   (acc "")
                   (in-bar nil)
                   (first-fragment nil))

               (labels
                   ((flush-bar ()
                      (push (list :quote-name acc :barred t)
                            out)
                      (setf acc ""
                            in-bar nil
                            first-fragment nil)))

                 (dolist (tok tokens)

                   (destructuring-bind (type value &rest tok-meta)
                       tok

                     (cond

                       ;; --------------------------------------------------
                       ;; BAR ENTRY
                       ;; --------------------------------------------------

                       ((and (not in-bar)
                             (member type '(:name :quote-name))
                             (str:starts-with-p "|" value))

                        (setf in-bar t
                              first-fragment t
                              acc (subseq value 1))

                        ;; one-token barred word: |foo|
                        (when (str:ends-with-p "|" acc)
                          (setf acc (subseq acc 0 (1- (length acc))))
                          (flush-bar)))

                       ;; --------------------------------------------------
                       ;; INSIDE BAR
                       ;; --------------------------------------------------

                       (in-bar

                        (let ((piece value))

                          ;; quoted fragments lost their leading "
                          (when (and (eq type :quote-name)
                                     (not first-fragment))
                            (setf piece
                                  (concatenate 'string "\"" piece)))

                          ;; closing fragment?
                          (if (str:ends-with-p "|" piece)

                              (progn
                                (setf piece
                                      (subseq piece
                                              0
                                              (1- (length piece))))
                                (setf acc
                                      (concatenate 'string acc piece))
                                (flush-bar))

                              (setf acc
                                    (concatenate 'string acc piece))))

                        (setf first-fragment nil))

                       ;; --------------------------------------------------
                       ;; NORMAL TOKEN
                       ;; --------------------------------------------------

                       (t
                        (push (append (list type value)
                                      tok-meta)
                              out)))))

                 (append (list :line (nreverse out))
                         line-meta))))))

      (append (list :tokens
                    (mapcar #'repair-line lines))))))

;; 2nd step: Checking structural balance of
;;           parentheses, brackets, and braces
;;           → document-level lexical analysis pass
;;      To-do **in the refinement**: making it incremental
;;                                   => The structure check can be updated
;;                                      from local changes, without rescanning
;;                                      the whole document.
;;            BUT: *After* everything else works: Reader->Evaluator->Printer

(defun analyse-structure (token+line-pairs)
  "Scan tokens and collect raw structural facts.
Returns a plist: (:depth <n> :issues <list>)."

  (let ((depth 0)
        (issues '())
        (stack '()))

    (dolist (pair token+line-pairs)
      (destructuring-bind (token . line) pair
        (case (first token)
          (:oparen   (incf depth) (push (cons token line) stack))
          (:obracket (incf depth) (push (cons token line) stack))
          (:obrace (incf depth) (push (cons token line) stack))

          (:cparen
           (if stack
               (progn (decf depth) (pop stack))
               (push (list :unexpected-close token :line line) issues)))

          (:cbracket
           (if stack
               (progn (decf depth) (pop stack))
               (push (list :unexpected-close token :line line) issues)))

          (:cbrace
           (if stack
               (progn (decf depth) (pop stack))
               (push (list :unexpected-close token :line line) issues))))))

    ;; leftover opens
    (dolist (open stack)
      (destructuring-bind (token . line) open
        (push (list :unclosed-open token :line line) issues)))

    ;; ALWAYS return a plist
    (list :depth depth
          :issues (nreverse issues))))

(defun classify-structure (scan &key (eof t))
  (let* ((depth  (getf scan :depth))
         (issues (getf scan :issues))
         (unexpected
           (remove-if-not (lambda (i)
                            (eq (first i) :unexpected-close))
                          issues)))
    (cond
      ;; 1. perfect
      ((and (= depth 0) (null issues))
       (list :status :balanced
             :depth 0
             :issues nil))

      ;; 2. structural contradictions
      ((not (null unexpected))
       (list :status :mismatch
             :depth depth
             :issues (nreverse issues)))

      ;; 3. only opens remain at EOF
      ((and eof (> depth 0))
       (list :status :incomplete
             :depth depth
             :issues (nreverse issues)))

      ;; 4. fallback
      (t
       (list :status :mismatch
             :depth depth
             :issues (nreverse issues))))))


(defun flatten-tokens-with-lines (token-lines)
  "Flatten token-lines into ((token . line-no) ...)."

  (mapcan
   (lambda (line)
     (destructuring-bind (tag tokens &key line-meta)
         line
       (declare (ignore tag))
       (let ((line-no (getf line-meta :line-no)))
         (mapcar (lambda (tok)
                   (cons tok line-no))
                 tokens))))
   token-lines))

(defun plist-put (plist key value)
  "Return a new plist like PLIST, but with KEY set to VALUE.
If KEY exists, its value is replaced.
If KEY does not exist, KEY and VALUE are appended."

  (let ((pos (position key plist :test #'eq)))
    (if pos
        (let ((result (copy-list plist)))
          (setf (nth (1+ pos) result) value)
          result)
        (append plist (list key value)))))

(defun check-structural-balance (token-tree)
  "Analyse delimiter structure and attach result to document meta layer."

  (destructuring-bind (tag token-lines &rest meta)
      token-tree

    ;; --------------------------------------------
    ;; Project tokens → (token . line-no)
    ;; --------------------------------------------
    (let* ((token+line-pairs
             (flatten-tokens-with-lines token-lines))

           ;; Phase 1: factual scan (no interpretation)
           (scan (analyse-structure token+line-pairs))

           ;; Phase 2: classify scan result (EOF semantics here)
           (classification (classify-structure scan :eof t))

           (status (getf classification :status))
           (depth  (getf classification :depth))
           (issues (getf classification :issues))

           ;; ----------------------------------------
           ;; Normalize meta
           ;; ----------------------------------------
           (meta-plist (copy-list meta))
           (existing-meta (getf meta-plist :meta)))

      ;; Ensure :meta exists and replace (not append!) structure + eof
      (setf (getf meta-plist :meta)
            (plist-put
             (plist-put existing-meta
                        :structure
                        (list :status status
                              :depth depth
                              :issues issues))
             :eof
             (list :status
                   (ecase status
                     (:balanced   :complete)
                     (:incomplete :incomplete)
                     (:mismatch   :error)))))

      ;; --------------------------------------------
      ;; Reassemble document
      ;; --------------------------------------------
      (cons tag
            (cons token-lines
                  meta-plist)))))

;; 3d step: Verbalization is lexical enrichment
;;           = selective semantic lifting over lexical atoms
;;
;;           first semantic commitment:
;;                 :names become plain wd-structures

(defun normalize-minus (tokens)
  "Resolve '-' into either unary MINUS (procedure word) or leave it as infix '-' for later infix processing.

The resolution of cases like  sum :a - 4 -> sum :a minus 4 is deliberately postponed."
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
  (destructuring-bind (tag tokens &rest meta)
      line
    (list* tag
           (normalize-minus tokens)
           meta)))

(defun normalize-minus-in-tree (token-tree)
  (destructuring-bind (tag lines &rest meta)
      token-tree
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
  (destructuring-bind (tag tokens &rest meta)
      line
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


;; Before infix elimination, arithmetic is only annotated text;
;; after infix elimination, it becomes executable structure.

;; Now the moment is reached when this transition begins.

(defun replace-infix-token (token)
  (cond
    ((and (wd-p token)
          (member :infix (wd-flags token)))
     (or (lookup-infix (wd-str token))
         token))   ;; unknown infix preserved verbatim
    (t token)))

(defun replace-infix-line (line)
  (destructuring-bind (line-tag elements &rest comment)
      line
    
    (list* line-tag
           (mapcar #'replace-infix-token elements)
           comment)))

(defun replace-infix-lines (token-tree)
  (destructuring-bind (tag lines &rest meta)
      token-tree
    (list* tag
           (mapcar #'replace-infix-line lines)
           meta)))




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
