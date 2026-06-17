(in-package #:logo)

;;; Logo   = a pedagogical restriction of Lisp-like representations that 
;;;          enforces a different execution model.
;;; cλogos =  a distinct evaluation model implemented inside Common Lisp, 
;;;           using Common Lisp as a substrate

;;; Common Lisp evaluates expressions, or:
;;;             CL runs code.
;;;
;;; Logo interprets programs represented as data, or:
;;;             Logo runs *descriptions of code*.
;;;             If something influences Logo behaviour,
;;;             it must be explicit data.
;;;       The reader discovers structure.
;;;       The elaborator discovers roles.
;;;       The evaluator performs meaning.

;;; Rule of thumb (Logo semantics)
;;;    Constructors trust.
;;;    Selectors verify.
;;;    Mutators enforce.

;;; cλogos intentionally does not implement the Logo macro system.
;;; Control abstractions are expressed via procedures and instruction lists.
;;; Advanced syntactic abstraction is introduced later via Common Lisp macros,
;;; as part of the learner’s transition to Lisp.

;;; cλogos will include a prototype-based object system inspired by Berkeley Logo.
;;; It is intended as an educational extension, preserving Logo’s simplicity
;;; while enabling structured modeling.
;;; Internally, it will be implemented using Common Lisp facilities, but the exposed
;;; semantics remain object-based rather than class-based.

(defun truth (true)
  (cond ((eq true t)
         (values +logo-true+ t))
        ((not true)
         (values +logo-false+ nil))
        (t (error "~A is not a truth value." true))))

(defun predicate->cl-truth (pred thing)
  "CL-TRUTH pred thing

extracts T or NIL from a Logo PREDicate testing THING, whose first return value is either TRUE or FALSE."
  (multiple-value-bind (_ truth)
      (funcall pred thing)
    (declare (ignore _))                ; prevents "_ unused" warning
    truth))

;;;; ======================================================================
;;;;
;;;;               Procedures and Glossary (c-Logo-s extension)
;;;;             Glossary = Meta definition layer for procedures
;;;;                  side-effecting declarative annotations
;;;;
;;;;
;;;;   Functionality possibly to be added later:
;;;;   - versioning / history
;;;;   - multiple glosses per name
;;;;   - inheritance / fallback between obarrays
;;;;   - concurrency protection
;;;;   - persistence / image saving
;;;; ======================================================================


(defun proc-obarray (pkg)
  (cond ((eq pkg 'logo) *primitive-obarray*)
        ((eq pkg 'logo/library) *library-obarray*)
        ((eq pkg 'logo/workspace) *workspace-obarray*)
        (t (error "Unknown procedure package: ~A" pkg))))

(defun build-gloss-from-definition (name source &key help-text-wd
                                                     (evaluation-model :normal) 
                                                     (kind :procedure))
  (make-gloss :name name
                   :source source
                   :help-text (and help-text-wd
                                   (wd-str help-text-wd))
                   :evaluation-model evaluation-model
                   :kind kind))

(defun define-procedure (&key name
                              package
                              implementation
                              default-arity
                              optional-arity
                              (visibility :public)
                              source
                              help-wd
                              (evaluation-model :normal) 
                              (kind :procedure))
  (let* ((obarray (proc-obarray package))
         (existing (gethash name obarray)))
    (setf (gethash name obarray)
          (make-proc :name name
                          :package package
                          :implementation implementation
                          :default-arity default-arity
                          :optional-arity optional-arity
                          :visibility visibility))
    (setf (gethash name *glossary-table*)
          (build-gloss-from-definition name source
                                       :help-text-wd help-wd 
                                       :evaluation-model evaluation-model
                                       :kind kind))
    existing))

(defun set-gloss (name help-wd &optional source)
  (let ((old-gloss (gethash name *glossary-table*)))

    (unless old-gloss
      (error "I don't know how to ~A." name))

    (let ((new-gloss (build-gloss-from-definition name
                                                  (or source
                                                      (gloss-source old-gloss))
                                                  :help-text-wd help-wd
                                                  :evaluation-model (gloss-evaluation-model old-gloss)
                                                  :kind (gloss-kind old-gloss))))
      (setf (gethash name *glossary-table*) new-gloss)

      new-gloss)))

(defun set-proc (name package implementation)
  (let* ((obarray (proc-obarray package))
         (old-proc (gethash name obarray)))

    (unless old-proc
      (error "Unknown procedure: ~A" name))

    (let ((new-proc
           (make-proc :name (proc-name old-proc)
                           :package package
                           :implementation implementation
                           :default-arity (proc-default-arity old-proc)
                           :optional-arity (proc-optional-arity old-proc)
                           :visibility (proc-visibility old-proc))))

      (setf (gethash name obarray) new-proc)

      new-proc)))

(defun set-buried (name package)
  (let* ((table (proc-obarray package))
         (proc (gethash name table)))
    (unless proc
      (error "Unknown procedure ~A" name))

    (setf (gethash name table)
          (make-proc
           :name (proc-name proc)
           :package (proc-package proc)
           :implementation (proc-implementation proc)
           :default-arity (proc-default-arity proc)
           :optional-arity (proc-optional-arity proc)
           :visibility :buried))))

(defun set-public (name package)
  (let* ((table (proc-obarray package))
         (proc (gethash name table)))
    (unless proc
      (error "Unknown procedure ~A" name))

    (setf (gethash name table)
          (make-proc
           :name (proc-name proc)
           :package (proc-package proc)
           :implementation (proc-implementation proc)
           :default-arity (proc-default-arity proc)
           :optional-arity (proc-optional-arity proc)
           :visibility :public))))

(defun lookup-procedure (name &key (include-buried nil))
  (let ((proc (or (gethash name *primitive-obarray*)
                  (gethash name *library-obarray*)
                  (gethash name *workspace-obarray*))))
    
    (unless (and proc
                 (not include-buried)
                 (eq (proc-visibility proc) :buried))
      proc)))

(defun ensure-proc (thing)
  (cond ((proc-p thing) thing)
        ((stringp thing) (lookup-procedure thing))
        (t NIL)))

(defun proc-place (proc-or-name place)
  (let ((proc (ensure-proc proc-or-name)))
    (when proc
      (ecase place
        (:package          (proc-package proc))
        (:implementation   (proc-implementation proc))
        (:default-arity    (proc-default-arity proc))
        (:optional-arity   (proc-optional-arity proc))
        (:visibility       (proc-visibility proc))))))

(defun lookup-gloss (name)
  (gethash name *glossary-table*))

(defun ensure-gloss (thing)
  (cond ((gloss-p thing) thing)
        ((stringp thing) (lookup-gloss thing))
        (t NIL)))

(defun gloss-place (gloss-or-name place)
  (let ((gloss (ensure-gloss gloss-or-name)))
    (when gloss
      (ecase place
        (:source (gloss-source gloss))
        (:help-text (gloss-help-text gloss))
        (:evaluation-model (gloss-evaluation-model gloss))
        (:kind (gloss-kind gloss))))))



;;; =================================================================
;;;                     Logo's core data type: WORD.
;;;                     ----------------------------
;;;   Meaning:  A Logo word (WD) is an immutable atomic symbolic unit,
;;;             constructed via coercion, composed via structural
;;;             concatenation, and never treated as a raw string in
;;;             the language layer.
;;;
;;;   Contract: A WD has
;;;              * a string representation ( str )
;;;              * an optional numeric interpretation ( nmb )
;;;
;;;   Invariants: * WD is immutable
;;;               * (WD-P X) -> X is a valid Logo word structure.
;;;               * STR is always a string.
;;;               * NMB is either a number or NIL.
;;;
;;;   Semantic rule: A word is *primarily symbolic*, not numeric.
;;;                  Numeric interpretation is secondary.


;; Invariant A -- Representation isolation:
;;      Only these functions may touch WD internals:
;;          * LOGO-WD and friends
;;          * LOGO-CONCAT
;;          * LOGO-COUNT
;;          * internal predicates
;;
;;      Everything else uses *WD as an opaque value*.
;;
;; Invariant B -- No raw string leakage upward:
;;      No Logo-level function may assume:
;;        "I am working on a string."
;;      Everything must go through ```(wd-str x)```
;;        or higher abstraction.
;;
;; Invariant C -- Coercion boundary rule:
;;      Any function that accepts "user-facing inputs"
;;      must ensure:
;;        *all inputs are coerced before structural operations*.
;;      This prevents silent type drift.
;;
;; Invariant D -- Word is the atomic semantic unit:
;;      *Logo does NOT operate on strings -- only on words.*

;; Internal word constructors
(defun parse-nmb (str)
  "PARSE-NMB str (auxiliary function)

returns numeric value of STR if it is a valid number literal, else NIL."
  (when ;; Prevent empty string "" of empty word from
      ;; INVALID-ARRAY-INDEX-ERROR with PARSE-NUMBER:
      (and (stringp str)
           (> (length str) 0)
           ;; must contain at least one digit
           (some #'digit-char-p str)) 
    ;; Handle possible parse errors:
    (handler-case  
        (parse-number:parse-number str)
    
      (parse-number:invalid-number ()
        nil)
      (parse-error () 
        nil))))

(defun numeric-literal-p (str)
  "NUMERIC-LITERAL-P str (auxiliary function)

returns T if STR can be represents a number."
  (numberp (parse-nmb str)))

(defun logo-wd (&optional (str ""))
  "LOGO-WD str (internal constructor)

outputs a plain Logo word."
  (declare (type string str))
  (make-wd :str str
           :nmb (parse-nmb str)
           :sym nil
           :flags '()))

(defun enrich-word (wd &key quoted thing infix barred generated)
  "ENRICH-WORD wd &key quoted thing infix barred (internal constructor)

outputs a Logo word with meta information about its provenance. "
  (make-wd :str (wd-str wd)
           :nmb (wd-nmb wd)
           :sym (wd-sym wd)
           :flags (remove nil
                          (append (wd-flags wd)
                                  (when quoted '(:quoted))
                                  (when thing  '(:thing))
                                  (when infix  '(:infix))
                                  (when barred '(:barred))
                                  (when generated '(:generated))))))

;; COERCION
;; Meaning: Coercion defines how non-Logo values enter
;;          the Logo world.
;;
;; Contract: Accepts WD, STRING, NUMBER.
;;           Rejects everything else (for now).
;;
;; Rules: * If already WD -> identity
;;        * If STRING -> WD(STR)
;;        * If NUMBER -> WD(PRINC-TO-STRING NUMBER)
;;        * Otherwise -> error (Logo-level condition later)
;;
;; Invariant: Coercion is the *only entry point*
;;                            *into the Logo word domain*.
;;            No other function may directly construct WD
;;            *from raw CL types*.
(defun coerce-wd (thing)
  "COERCE-WD thing (library function)

coerces THING to a Logo word if it is a string or a number. Returns THING if it is a word already. THING being neither a string or a number is an error."
  (cond ((wd-p thing) thing)
        ((stringp thing) (logo-wd thing))
        ((numberp thing) (logo-wd (princ-to-string thing)))
        (t
         
         ;; This will be replaced by a condition later:
         (error 'type-error
                :datum thing
                :expected-type '(or wd string number)))))


;;;; ======================================================================

;;;; Logo Templates:
;;;; ===============
;;;;       'Template' is the Logo term for an executable object that represents
;;;;       a procedure body to be invoked by another procedure.  
;;;;
;;;;       Five syntactical versions of templates exist:
;;;;
;;;;       * 'instruction list' form, e.g.:
;;;;         ```[print "hello]```
;;;;
;;;;         This translates to Common Lisp in principle as:
;;;;         ```(lambda () (logo-print (coerce-wd "hello")))```
;;;;
;;;;       * 'explicit-slot' form, or 'question mark' form, e.g.:
;;;;  
;;;;         ```[? * ?]``` or ```[product ? ?]```
;;;;         ```[difference ?1 ?2 ?3]```
;;;;
;;;;         This translates to Common Lisp in principle as:
;;;;         ```(lambda (?) (* ? ?)```
;;;;         ```(lambda (?1 ?2 ?3) (- ?1 ?2 ?3)```
;;;;
;;;;       IMPORTANT: Slot names inside templates introduce bindings,
;;;;                  not variable references, analogous to lambda
;;;;                  parameters in Common Lisp. So slot names are no words.
;;;;
;;;;       * 'named-slot' form, or 'lambda' form, e.g.:
;;;;
;;;;         ```[fac * fac]``` or ```[product fac fac]```
;;;;         ```[difference sub1 sub2 sub3]```
;;;;
;;;;         This translates to Common Lisp in principle as:
;;;;         ```(lambda (fac) (* fac fac)```
;;;;         ```(lambda (sub1 sub2 sub3) (- sub1 sub2 sub3)```
;;;;
;;;;       * 'procedure text' form with at least two members, all of 
;;;;         which are lists, e.g.:
;;;;
;;;;         ```[[fac1 fac2] [product fac1 fac2]]```
;;;;
;;;;         This translates to Common Lisp in principle as:
;;;;         ```(lambda (fac1 fac2) (* fac1 fac2)```
;;;;
;;;;       * 'named-procedure' form, in which a word naming a procedure
;;;;          is implicitly coerced into a template when passed as an
;;;;          argument, e.g.:
;;;;
;;;;         ```show (logo-map "word [a b c] [d e f])```
;;;;
;;;;         This translates to Common Lisp in principle as:
;;;;         ```(show (mapcar #'word 
;;;;                          (list (coerce-wd "a") (coerce-wd "b") (coerce-wd "c")) 
;;;;                          (list (coerce-wd "d") (coerce-wd "e") (coerce-wd "f"))))```


;;;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;;
;;;;                        Language Microworld
;;;;
;;;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


(defun logo-concat (wd1 wd2)
  "LOGO-CONCAT word1 word2 (internal constructor)

joins two Logo words and returns them as a new word.  It is used by WORD."
  (coerce-wd (str:concat (wd-str wd1)
                         (wd-str wd2))))

;; Internal word selectors
(defun logo-wd->cl-number (wd)
  "LOGO-WD->CL-NUMBER wd

returns either the number word WD as Common Lisp number, or NIL."
  (wd-nmb wd))

(defun logo-wd-item (idx wd)
  "LOGO-WD-ITEM idx wd (internal data selector)

outputs the character in WD which is specified by index number IDX."
  (coerce-wd (str:s-nth (wd-nmb idx) (wd-str wd))))

(defun logo-wd-first (wd)
  "LOGO-WD-FIRST wd (internal data selector)

outputs the first of WD."
  (coerce-wd (str:s-first (wd-str wd))))

(defun logo-wd-last (wd)
  "LOGO-WD-LAST wd (internal data selector)

outputs the last of WD."
  (coerce-wd (str:s-last (wd-str wd))))

(defun logo-wd-butfirst (wd)
  "LOGO-WD-BUTFIRST wd (internal data selector)

outputs the butfirst of WD."
  (coerce-wd (str:s-rest (wd-str wd))))

(defun logo-wd-butlast (wd)
  "LOGO-WD-BUTLAST wd (internal data selector)

outputs the butlast of WD."
  (let ((w (wd-str wd)))
    (coerce-wd (str:substring 0
                              (1- (length w))
                              w))))

;; Internal word query
(defun logo-wd-count (wd)
  (length (wd-str wd)))


;; 2 Data structure primitives:
;; ----------------------------

;; 2.1 Logo constructor WORD (operation)
;;
;;     Meaning: WORD constructs a new word by concatenation
;;              of representations.
;;
;;     Contract: Input
;;               * any number of Logo values
;;               Output:
;;               * a WD
;;
;;     Invariants: * Inputs are *coerced to words before use*
;;                 * Output is always a fresh WD
;;                 * Concatenation is associative in effect:
;;                   ```(word a b c) == (word (word a b) c)```
;;
;;     Semantic rule: WORD is a *structural composition operator*
;;                              *over symbolic values.*
;;                    Not a string function.
(defun word (word1 word2 &rest words)
  "WORD word1 word2
(WORD word1 word2 word3 ...)

outputs a word formed by concatenating its inputs."
  (reduce #'logo-concat
          (append (list word1 word2) words)))

(define-procedure :name "word"
                  :package 'logo
                  :implementation #'word
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'word 'function))
                                        :barred t)
                  :default-arity 2 
                  :optional-arity -1
                  :kind :operation)

;; 2.4 Logo predicate:
(defun wordp (thing)
  "WORDP thing
WORD? thing

outputs TRUE if the input is a word, FALSE otherwise."
  (if (wd-p thing)
      (values +logo-true+ t)
      (values +logo-false+ nil)))

(define-procedure :name "wordp"
                  :package 'logo
                  :implementation #'wordp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'wordp 'function))
                                        :barred t)
                  :default-arity 2 
                  :kind :operation)
(define-procedure :name "word?"
                  :package 'logo
                  :implementation #'wordp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'wordp 'function))
                                        :barred t)
                  :default-arity 2 
                  :kind :operation)

;;; =========================================================


;;; =====================================================================
;;;                   Logo's sequences: Lists and Arrays
;;;                   ----------------------------------
;;;
;;;  A Logo sequence is either a Common Lisp list or a Logo array,
;;;  a struct containing a CL array and a slot for the index origin.
;;;  Strings are excluded, because they live in the word domain.
;;;

;; Logo array
;;   Invariant: (Array indexing)
;;              Logo arrays store data in zero-based vectors.
;;              All Logo-visible indexing is translated by subtracting
;;              the array’s origin.

;; 2.1 Constructors
;; called by the reader/parser for literals with:
;; (make-logo-list parsed-elements :origin :literal)
(defun make-logo-list (elements &key (origin :runtime))
  (let ((flatp (every #'atom elements)))
    (%make-logo-list :data elements
                     :flatp flatp
                     :origin origin)))


(defun logo-list (&rest things)
  "LIST thing1 thing2
(LIST thing1 thing2 thing3 ...)

outputs a list whose members are its inputs, which can be any Logo datum (word, list, or
array)."
  (unless (>= (length things) 2)
    ;; to be refined later
    (error "not enough inputs to list"))
  (make-logo-list things :origin :runtime))

(define-procedure :name "list"
                  :package 'logo
                  :implementation #'logo-list
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-list 'function))
                                        :barred t)
                  :default-arity 2 
                  :optional-arity -1
                  :kind :operation)

(defun sentence (&rest things)
  "SENTENCE thing1 thing2
SE thing1 thing2
(SENTENCE thing1 thing2 thing3 ...)
(SE thing1 thing2 thing3 ...)

outputs a list whose members are its inputs, if those inputs are not lists, or the members
of its inputs, if those inputs are lists."
  ;; Sentence produces a *one-level* flat list but it is *not* a flattening function.
  ;; It is a normalization + concatenation function:
  (unless (>= (length things) 2)
    ;; to be refined later
    (error "not enough inputs to list"))
  (flet ((sent-fragment (x)
           (cond ((wd-p x) (list x))    ;  word->list
                 ((logo-list-p x) x)          ;  list->list
                 ((logo-array-p x)      ; array->list
                  (coerce (logo-array-data x) 'list))
                 (t
                  ;; to be refined later
                  (error "[sentence] doesn't like [non-word/list/array] as input.")))))
    (apply ;; concatenate (step 2):
     #'append
     (mapcar ;; normalize (step 1):
      #'sent-fragment things))))

(define-procedure :name "sentence"
                  :package 'logo
                  :implementation #'sentence
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'sentence 'function))
                                        :barred t)
                  :default-arity 2 
                  :optional-arity -1
                  :kind :operation)

(define-procedure :name "se"
                  :package 'logo
                  :implementation #'sentence
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'sentence 'function))
                                        :barred t)
                  :default-arity 2 
                  :optional-arity -1
                  :kind :operation)

(defun logo-array (size &optional (origin 1))
  "ARRAY size
(ARRAY size origin)

outputs an array of size members (must be a positive integer), each of which initially is an empty list. Array members can be selected with ITEM and changed with SETITEM. The first member of the array is member number 1 unless an origin input (must be an integer) is given, in which case the first member of the array has that number as its index. (Typically 0 is used as the origin if anything.) Arrays are printed by PRINT and friends, and can be typed in, inside curly braces; indicate an origin with {a b c}@0."
  (make-logo-array :data (make-array size :initial-element (%make-logo-list :data '() :flatp t))
                   :origin origin))

(define-procedure :name "array"
                  :package 'logo
                  :implementation #'logo-array
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-array 'function))
                                        :barred t)
                  :default-arity 1
                  :optional-arity 2
                  :kind :operation)

;; 2.4 Predicate

(defun logo-arrayp (thing)
  "ARRAYP thing
ARRAY? thing
outputs TRUE if the input is an array, FALSE otherwise."
  (if (logo-array-p thing)
      (values +logo-true+ T)
      (values +logo-false+ NIL)))

(define-procedure :name "arrayp"
                  :package 'logo
                  :implementation #'logo-arrayp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-arrayp 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)

(define-procedure :name "array?"
                  :package 'logo
                  :implementation #'logo-arrayp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-arrayp 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)

(defun logo-listp (thing)
  "LISTP thing
LIST? thing

outputs TRUE if the input is a list, FALSE otherwise."
  (if (logo-list-p thing)
      (values +logo-true+ T)
      (values +logo-false+ NIL)))

;; 2.3 Data mutator
(defun setitem (index array value)
  "SETITEM index array value

command. Replaces the indexth member of array with the new value. Ensures that the
resulting array is not circular, i.e., value may not be a list or array that contains ARRAY."
  ;; implementation of circularity check  is postponed, but will be later
  (setf (aref (logo-array-data array)
              (- (logo-wd->cl-number index) (logo-array-origin array)))
        value)
  array)

(define-procedure :name "setitem"
                  :package 'logo
                  :implementation #'setitem
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'setitem 'function))
                                        :barred t)
                  :default-arity 3
                  :kind :operation)

;; Internal predicate
(defun logo-sequencep (thing)
  "SEQUENCEP thing
SEQUENCE? thing

outputs TRUE if the input is a Logo sequence, FALSE otherwise."
  (and (not (stringp thing))
       (or (logo-list-p thing)
           (logo-array-p thing))))

;; Gateway to the sequence domain,
;; maybe later becoming ENSURE-SEQUENCE, for Logo-level coercion.
(defun assert-sequence (thing)
  "ASSERT-SEQUENCE thing

outputs thing if it is a Logo sequence, else it reports an error."
  (cond ((logo-sequencep thing) thing)
        (t

         ;; This will be replaced by a condition later:
         (error 'type-error
                :datum thing
                :expected-type '(or logo-list logo-array)))))

;; Internal query:
(defun logo-seq-count (seq)
  (cond ((logo-list-p seq) (length (logo-list-data seq)))
        ((logo-array-p seq) (length (logo-array-data seq)))))

;; Internal Data Selector:
(defun logo-seq-item (idx seq)
  (cond ((logo-list-p seq) (nth idx (logo-list-data seq)))
        ((logo-array-p seq) (aref (logo-array-data seq)
                                  (- idx (logo-array-origin seq))))))

(defun logo-array-first (arr)
  (logo-array-origin arr))

(defun logo-lst-first (lst)
  (first (logo-list-data lst)))

(defun logo-lst-last (lst)
  (car (last (logo-list-data lst))))

(defun logo-lst-butfirst (lst)
  (rest (logo-list-data lst)))

(defun logo-lst-butlast (lst)
  (butlast (logo-list-data lst)))

;;; ==========================================================================


;;; Generic dispatcher functions

;; 2.5 Query:
(defun logo-count (thing)
  "COUNT thing

outputs the number of characters in the input, if the input is a word; outputs the number of members in the input, if it is a list or an array. (For an array, this may or may not be the index of the last member, depending on the array’s origin.)"
  (cond ((wd-p thing) (logo-wd-count thing))
        ((logo-sequencep thing) (logo-seq-count thing))
        (t

         ;; This will be replaced by a condition later:
         (error 'type-error
                :datum thing
                :expected-type '(or wd list array)))))

(define-procedure :name "count"
                  :package 'logo
                  :implementation #'logo-count
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-count 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)


;; 2.2 Selectors
(defun item (index thing)
  "ITEM index thing

if the thing is a word, outputs the indexth character of the word. If the thing is a list,
outputs the indexth member of the list. If the thing is an array, outputs the indexth
member of the array. Index starts at 1 for words and lists; the starting index of an array is
specified when the array is created."
  (cond ((wd-p thing) (logo-wd-item (1- (logo-wd->cl-number index))  thing))
        ((logo-list-p thing) (logo-seq-item (1- (logo-wd->cl-number index)) thing))
        ((logo-array-p thing) (logo-seq-item (logo-wd->cl-number index) thing))
        (t

         ;; This will be replaced by a condition later:
         (error 'type-error
                :datum thing
                :expected-type '(or wd list array)))))

(define-procedure :name "item"
                  :package 'logo
                  :implementation #'item
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'item 'function))
                                        :barred t)
                  :default-arity 2 
                  :kind :operation)

(defun logo-first (thing)
  "FIRST thing

if the input is a word, outputs the first character of the word. If the input is a list, outputs
the first member of the list. If the input is an array, outputs the origin of the array (that
is, the index of the first member of the array)."
  (cond ((wd-p thing) (logo-wd-item 0 thing))           ; first character (data)
        ((logo-list-p thing) (logo-lst-first thing))    ; first element (data)
        ((logo-array-p thing) (logo-array-first thing)) ; origin number (meta data)
        (t

         ;; This will be replaced by a condition later:
         (error 'type-error
                :datum thing
                :expected-type '(or wd list logo-array)))))

(define-procedure :name "first"
                  :package 'logo
                  :implementation #'logo-first
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-first 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)

(defun logo-last (wordorlist)
  "LAST wordorlist

if the input is a word, outputs the last character of the word. If the input is a list, outputs
the last member of the list."
  (cond ((wd-p wordorlist) (logo-wd-last wordorlist))
        ((logo-list-p wordorlist) (logo-lst-last wordorlist))
        (t

         ;; This will be replaced by a condition later:
         (error 'type-error
                :datum wordorlist
                :expected-type '(or wd list)))))

(define-procedure :name "last"
                  :package 'logo
                  :implementation #'logo-last
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-last 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)

(defun logo-butfirst (wordorlist)
  "BUTFIRST wordorlist
BF wordorlist

if the input is a word, outputs a word containing all but the first character of the input. If
the input is a list, outputs a list containing all but the first member of the input."
  (cond ((wd-p wordorlist) (logo-wd-butfirst wordorlist))
        ((logo-list-p listp wordorlist) (logo-lst-butfirst wordorlist))
        (t

         ;; This will be replaced by a condition later:
         (error 'type-error
                :datum wordorlist
                :expected-type '(or wd list)))))

(define-procedure :name "butfirst"
                  :package 'logo
                  :implementation #'logo-butfirst
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-butfirst 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)

(define-procedure :name "bf"
                  :package 'logo
                  :implementation #'logo-butfirst
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-butfirst 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)

(defun logo-butlast (wordorlist)
  "BUTLAST wordorlist
BL wordorlist

if the input is a word, outputs a word containing all but the last character of the input. If
the input is a list, outputs a list containing all but the last member of the input."
  (cond ((wd-p wordorlist) (logo-wd-butlast wordorlist))
        ((logo-list-p wordorlist) (logo-lst-butlast wordorlist))
        (t

         ;; This will be replaced by a condition later:
         (error 'type-error
                :datum wordorlist
                :expected-type '(or wd list)))))

(define-procedure :name "butlast"
                  :package 'logo
                  :implementation #'logo-butlast
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-butlast 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)

(define-procedure :name "bl"
                  :package 'logo
                  :implementation #'logo-butlast
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-butlast 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)

;; 2.4 Predicate:
(defun emptyp (thing)
  "EMPTYP thing
EMPTY? thing

outputs TRUE if the input is the empty word or the empty list, FALSE otherwise."
  (cond ((and (logo-list-p thing)
              (null (logo-list-data thing)))         
         (values +logo-true+ t))
        ((wd-p thing)
         (if (string= (wd-str thing) "")
             (values +logo-true+ t)
             (values +logo-false+ nil)))
        (t
         (values +logo-false+ nil))))

(define-procedure :name "emptyp"
                  :package 'logo
                  :implementation #'emptyp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'emptyp 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)

(define-procedure :name "empty?"
                  :package 'logo
                  :implementation #'emptyp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'emptyp 'function))
                                        :barred t)
                  :default-arity 1 
                  :kind :operation)



(defgeneric logo-equalp* (thing1 thing2)
  (:documentation "Auxiliary function for Logo's
EQUALP thing1 thing2
EQUAL? thing1 thing2
thing1 = thing2

outputs T if the inputs are equal in the Logo sense, NIL otherwise. Two numbers are equal if they have the same numeric value. Two non-numeric words are equal if they contain the same characters in the same order.  Two lists are equal if their members are equal. An array is only equal to itself; two separately created arrays are never equal even if their members are equal.

LOGO-EQUALP* returns the Common Lisp booleans, and LOGO-EQUALP wraps around LOGO-EQUALP* to return Logo and Common Lisp booleans."))

;; just a placeholder for a later special Logo variable,
;; when the Logo variable system becomes alive:
(defparameter caseignoredp t)

(defmethod logo-equalp* ((thing1 wd) (thing2 wd))
  (let* ((nmb1 (wd-nmb thing1))
         (nmb2 (wd-nmb thing2)))
    (cond ((and nmb1 nmb2)
           (= nmb1 nmb2))
          ((not (and nmb1 nmb2))
           (if caseignoredp
               (string-equal (wd-str thing1) (wd-str thing2))
               (string= (wd-str thing1) (wd-str thing2))))
          (t nil))))

(defmethod logo-equalp* ((thing1 logo-list) (thing2 logo-list))
  (let ((ps (logo-list-data thing1))
        (qs (logo-list-data thing2)))
    (and (= (length ps) (length qs))
         (every #'logo-equalp* ps qs))))

(defmethod logo-equalp* ((thing1 logo-array) (thing2 logo-array))
  (eq thing1 thing2))

(defmethod logo-equalp* ((a t) (b t))
  nil)

(defun logo-equalp (thing1 thing2)
  "EQUALP thing1 thing2
EQUAL? thing1 thing2
thing1 = thing2

outputs TRUE if the inputs are equal, FALSE otherwise. Two numbers are equal if they have the same numeric value. Two non-numeric words are equal if they contain the same characters in the same order. If there is a variable named CASEIGNOREDP whose value is TRUE, then an upper case letter is considered the same as the corresponding lower case letter. (This is the case by default.) Two lists are equal if their members are equal. An array is only equal to itself; two separately created arrays are never equal even if their members are equal. (It is important to be able to know if two expressions have the same array as their value because arrays are mutable; if, for example, two variables have the same array as their values then performing SETITEM on one of them will also change the other.) 

See [CASEIGNOREDP], page 95, , [SETITEM], page 12.)"
  (truth (logo-equalp* thing1 thing2)))

(define-procedure :name "equalp"
                  :package 'logo
                  :implementation #'logo-equalp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-equalp 'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

(define-procedure :name "equal?"
                  :package 'logo
                  :implementation #'logo-equalp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-equalp 'function))
                                        :barred t)
                  :default-arity 2 
                  :kind :operation)

;;; 4.1 Transmitter

(defgeneric render-node (node context)
  (:documentation "RENDER-NODE node context

Render a *render node* (RNODE) into its textual representation according to
a PRINT-CONTEXT.

This function belongs exclusively to the *presentation layer* of the Logo
system. It does not inspect or manipulate semantic Logo values such as WD,
LOGO-LIST, or LOGO-ARRAY directly.

Conceptual role:

  Semantic value  →  RNODE  →  text

RENDER-NODE performs the final step of this pipeline.

Responsibilities:
- Interpret the structural kind of NODE (word, list, array, etc.)
- Apply presentation rules supplied by CONTEXT (brackets, braces, separators)
- Recursively render child nodes when NODE is composite
- Produce a string suitable for output (PRINT, SHOW, etc.)

Non-responsibilities:
- No evaluation of Logo expressions
- No mutation of Logo data
- No parsing or construction of Logo values
- No semantic decisions (e.g., equality, arithmetic, quoting)

Invariants:
- RENDER-NODE is pure with respect to Logo semantics
- All Logo-specific meaning has already been resolved before this stage
- Differences between PRINT and SHOW are expressed solely via CONTEXT

See also:
  VALUE->RNODE   ; constructs render nodes from semantic Logo values
  PRINT-CONTEXT  ; controls formatting policy
  SHOW, PRINT    ; user-facing commands built on this pipeline"))

(defun render-sequence (items context style)
  (let ((sep (print-context-separator context))
        (rendered (mapcar (lambda (x)
                            (render-node x context))
                          items)))
    (ecase style
      (:bare
       (format nil "~{~A~^~A~}" rendered sep))
      (:bracket
       (format nil "[~{~A~^~A~}]" rendered sep))
      (:brace
       (format nil "{~{~A~^~A~}}" rendered sep)))))

(defmethod render-node ((node rnode) context)
  (ecase (rnode-kind node)

    (:word
     (rnode-children node))

    (:list
     (render-sequence (rnode-children node)
                      context
                      (print-context-list-style context)))

    (:array
     (render-sequence (rnode-children node)
                      context
                      (print-context-array-style context)))))

(defgeneric value->rnode (thing)
  (:documentation "Constructor for the print tree."))


(defmethod value->rnode ((w wd))
  (make-rnode :kind :word
              :value (wd-str w)))

(defmethod value->rnode ((l logo-list))
  (make-rnode :kind :list
              :children (mapcar #'value->rnode
                                (logo-list-data l))))

(defmethod value->rnode ((a logo-array))
  (make-rnode :kind :array
              :children (mapcar #'value->rnode
                                (coerce (logo-array-data a)
                                        'list))))
#|
(defun logo-sequence-elements (thing)
  (etypecase thing
    (logo-list (logo-list-data thing))
    (logo-array (coerce (logo-array-data thing) 'list))))

(defun format-sequence (thing items context)
  (let ((rendered (mapcar (lambda (x)
                            (logo-string x context))
                          items)))
    (ecase (typecase thing
             (logo-list :list)
             (logo-array :array))
      (:list
       (ecase (print-context-list-style context)
         (:bare    (format nil "~{~A~^ ~}" rendered))
         (:bracket (format nil "[~{~A~^ ~}]" rendered))))
      (:array
       (ecase (print-context-array-style context)
         (:bare    (format nil "~{~A~^ ~}" rendered))
         (:brace   (format nil "{~{~A~^ ~}}" rendered)))))))

(defgeneric logo-string (thing context)
g  (:documentation ""))

(defmethod logo-string ((thing wd) context)
  (wd-str thing))

(defmethod logo-string ((thing logo-list) context)
  (format-sequence thing (logo-sequence-elements thing) context))

(defmethod logo-string ((thing logo-array) context)
  (format-sequence thing (logo-sequence-elements thing) context))|#

(defun show (&rest things)
  "SHOW thing
(SHOW thing1 thing2 ...)

command. Prints the input or inputs like LOGO-PRINT, except that if an input is a list it is printed inside square brackets."
  (format t "~{~A~^ ~}~%"
          (mapcar (lambda (x)
                    (render-node (value->rnode x) *print-context*))
                  things)))

(define-procedure :name "show"
                  :package 'logo
                  :implementation #'show
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'show 'function))
                                        :barred t)
                  :default-arity 1
                  :optional-arity -1
                  :kind :command)

(defun logo-print (&rest things)
  "PRINT thing
PR thing
(PRINT thing1 thing2 ...)
(PR thing1 thing2 ...)

command. Prints the input or inputs to the current write stream (initially the screen). All
the inputs are printed on a single line, separated by spaces, ending with a newline. If an
input is a list, square brackets are not printed around it, but brackets are printed around
sublists. Braces are always printed around arrays."
  (format t "~{~A~^ ~}~%"
          (mapcar (lambda (x)
                    (render-node (value->rnode x) *print-context*))
                  things)))

(define-procedure :name "print"
                  :package 'logo
                  :implementation #'logo-print
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-print 'function))
                                        :barred t)
                  :default-arity 1
                  :optional-arity -1
                  :kind :command)

(define-procedure :name "pr"
                  :package 'logo
                  :implementation #'logo-print
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'logo-print 'function))
                                        :barred t)
                  :default-arity 1
                  :optional-arity -1
                  :kind :command)


;;;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;;
;;;;                        Mathematics Microworld
;;;;
;;;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;;; Arithmetic constructor

(defun nary-ari-op (operator operands)
  "NARY-ARI-OP operator operands

returns a numeric word that is the result of the arithmetic operation OPERATOR on the OPERANDS passed as a flat list of words (numeric or non-numeric variable names)."
  (coerce-wd (reduce operator (mapcar #'logo-wd->cl-number
                                      operands))))

;;; 5.1 Numeric Operations
(defun sum (&rest nums)
  "SUM num1 num2
(SUM num1 num2 num3 ...)

num1 + num2
outputs the sum of its inputs."
  (unless (>= (length nums) 2)
    ;; to be refined later
    (error "not enough inputs to list"))
  (nary-ari-op #'+ nums))

(define-procedure :name "sum"
                  :package 'logo
                  :implementation #'sum
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'sum 'function))
                                        :barred t)
                  :default-arity 2
                  :optional-arity -1
                  :kind :operation)

(defun difference (&rest nums)
  "DIFFERENCE num1 num2
(DIFFERENCE num1 num2 num3 ...)

num1 - num2
outputs the difference of its inputs."
  (unless (>= (length nums) 2)
    ;; to be refined later
    (error "not enough inputs to list"))
  (nary-ari-op #'- nums))

(define-procedure :name "difference"
                  :package 'logo
                  :implementation #'difference
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'difference 'function))
                                        :barred t)
                  :default-arity 2
                  :optional-arity -1
                  :kind :operation)

(defun minus (num)
  "MINUS num
     - num

outputs the negative of its input. Minus sign means unary minus if the previous token is an infix operator or open parenthesis, or it is preceded by a space and followed by a nonspace. 
There is a difference in binding strength between the two forms:

      MINUS 3 + 4 means -(3+4)
          - 3 + 4 means (-3)+4"
  (coerce-wd (- (logo-wd->cl-number num))))

(define-procedure :name "minus" 
                  :package 'logo
                  :implementation #'minus
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'minus 'function))
                                        :barred t)
                  :default-arity 1
                  :kind :operation)

(defun product (&rest nums)
  "PRODUCT num1 num2
(PRODUCT num1 num2 num3 ...)

prod1 * prod2
outputs the product of its inputs."
  (unless (>= (length nums) 2)
    ;; to be refined later
    (error "not enough inputs to list"))
  (nary-ari-op #'* nums))

(define-procedure :name "product"
                  :package 'logo
                  :implementation #'product
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'product 'function))
                                        :barred t)
                  :default-arity 2
                  :optional-arity -1
                  :kind :operation)

(defun quotient (&rest nums)
  "QUOTIENT num1 num2
(QUOTIENT num1 num2 num3 ...)

num1 / num2
outputs the quotient of its inputs."
  (unless (>= (length nums) 2)
    ;; to be refined later
    (error "not enough inputs to list"))
  (nary-ari-op #'/ nums))

(define-procedure :name "quotient"
                  :package 'logo
                  :implementation #'quotient
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'quotient
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :optional-arity -1
                  :kind :operation)

(defun power (num1 num2)
  "POWER num1 num2

outputs num1 to the num2 power. If num1 is negative, then num2 must be an integer."
  (expt num1 num2))

(define-procedure :name "power"
                  :package 'logo
                  :implementation #'power
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'power
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

;;; 5.2 Numeric Predicates
(defun lessp (num1 num2)
  "LESSP num1 num2
LESS? num1 num2
num1 < num2

outputs TRUE if its first input is strictly less than its second."
  (if (< (logo-wd->cl-number num1) (logo-wd->cl-number num2))
      (values +logo-true+ T)
      (values +logo-false+ NIL)))

(define-procedure :name "lessp"
                  :package 'logo
                  :implementation #'lessp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'lessp
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

(define-procedure :name "less?"
                  :package 'logo
                  :implementation #'lessp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'lessp
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

(defun greaterp (num1 num2)
  "GREATERP num1 num2
GREATER? num1 num2
num1 > num2

outputs TRUE if its first input is strictly greater than its second."
  (if (> (logo-wd->cl-number num1) (logo-wd->cl-number num2))
      (values +logo-true+ T)
      (values +logo-false+ NIL)))

(define-procedure :name "greaterp"
                  :package 'logo
                  :implementation #'greaterp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'greaterp
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

(define-procedure :name "greater?"
                  :package 'logo
                  :implementation #'greaterp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'greaterp
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

(defun lessequalp (num1 num2)
  "LESSP num1 num2
LESS? num1 num2
num1 <= num2

outputs TRUE if its first input is less than or equal to its second."
  (if (<= (logo-wd->cl-number num1) (logo-wd->cl-number num2))
      (values +logo-true+ T)
      (values +logo-false+ NIL)))

(define-procedure :name "lessequalp"
                  :package 'logo
                  :implementation #'lessequalp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'lessequalp
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

(define-procedure :name "lessequal?"
                  :package 'logo
                  :implementation #'lessequalp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'lessequalp
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

(defun greaterequalp (num1 num2)
  "LESSP num1 num2
LESS? num1 num2
num1 >= num2

outputs TRUE if its first input is greater than or equal to its second."
  (if (>= (logo-wd->cl-number num1) (logo-wd->cl-number num2))
      (values +logo-true+ T)
      (values +logo-false+ NIL)))

(define-procedure :name "greaterequalp"
                  :package 'logo
                  :implementation #'greaterequalp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'greaterequalp
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

(define-procedure :name "greaterequal?"
                  :package 'logo
                  :implementation #'greaterequalp
                  :source nil
                  :help-wd (enrich-word (logo-wd (documentation #'greaterequalp
                                                                'function))
                                        :barred t)
                  :default-arity 2
                  :kind :operation)

;;; Infix operators
;;; ---------------
;;;
;;; Convenience knowledge:
;;;   Infix notation is a surface convenience that is eliminated before
;;;   evaluation, but after syntactic structure becomes explicit.

;;;   Infix operators are first-class semantic objects:
;;;   syntax operator descriptors that reorganise their surrounding
;;;   syntactical structure.
;;
;;;   They are no procedures on their own.
;;;   They are replaced with their prefix procedures
;;;   in prefix position once their operands are determined.
;;;
;;;   Precedence:
;;;     ^        100
;;;     * /       80
;;;     + -       60
;;;     < > =     40
;;;     ←         20 


(defun define-infix (&key sign (weight 0) associativity procedure)
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
                      :associativity associativity
                      :procedure procedure))))

(defun lookup-infix (sign)
  "Return an INFIX structure or NIL. Never signals. Never infers."
  (or (gethash sign *workspace-infix-table*)
      (gethash sign *infix-table*)))


(define-infix :sign "^"
  :weight 100
  :associativity :right
  :procedure (lookup-procedure "power"))

(define-infix :sign "*"
  :weight 80
  :associativity :left
  :procedure (lookup-procedure "product"))

(define-infix :sign "×"
  :weight 80
  :associativity :left
  :procedure (lookup-procedure "product"))

(define-infix :sign "⋅"
  :weight 80
  :associativity :left
  :procedure (lookup-procedure "product"))

(define-infix :sign "/"
  :weight 80
  :associativity :left
  :procedure (lookup-procedure "quotient"))

(define-infix :sign "÷"
  :weight 80
  :associativity :left
  :procedure (lookup-procedure "quotient"))

(define-infix :sign "+"
  :weight 60
  :associativity :left
  :procedure (lookup-procedure "sum"))

(define-infix :sign "-"
  :weight 60
  :associativity :left
  :procedure (lookup-procedure "difference"))

(define-infix :sign "<"
  :weight 40
  :associativity :left
  :procedure (lookup-procedure "lessp"))

(define-infix :sign ">"
  :weight 40
  :associativity :left
  :procedure (lookup-procedure "greaterp"))

(define-infix :sign "="
  :weight 40
  :associativity :left
  :procedure (lookup-procedure "equalp"))

(define-infix :sign "<="
  :weight 40
  :associativity :left
  :procedure (lookup-procedure "lessequalp"))

(define-infix :sign "≤"
  :weight 40
  :associativity :left
  :procedure (lookup-procedure "lessequalp"))

(define-infix :sign ">="
  :weight 40
  :associativity :left
  :procedure (lookup-procedure "greaterequalp"))

(define-infix :sign "≥"
  :weight 40
  :associativity :left
  :procedure (lookup-procedure "greaterequalp"))

;; The ```make``` operator is write-protected!
;;(define-infix :sign "←"
;;  :weight 20
;;  :associativity :right
;;  :procedure (lookup-procedure "make"))

