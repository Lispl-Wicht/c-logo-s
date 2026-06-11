(in-package #:logo)

;;;; ======================================================================
;;;;
;;;;                         Procedure and gloss struct
;;;;
;;;; ======================================================================

(defstruct proc
  (name nil :type string)
  (package nil :type symbol)
  (implementation nil)             ; CL function | closure | opcode | AST | etc.
  (default-arity nil :type (or number null)) ; NIL = uninitialised
  (optional-arity nil :type (or number null)) ; NIL = no optional arity; -1 = arbitrary arity
  (visibility :public :type symbol)) ; :public | :buried

(defstruct gloss
  (name nil :type (or string null))
  (source nil)                          ; original definition
  (help-text nil :type (or string null))
  (evaluation-model :normal :type symbol) ; :special | :control | :syntax
  (kind :procedure :type symbol)) ; :command | :operation | :directive

;;;;  =====================================================================
;;;;
;;;;                          BLOS objects
;;;;
;;;;  =====================================================================

;;;   BLOS favors alists over hash tables because objects are small,
;;;   inheritance dominates lookup cost, and transparency is
;;;   a first-class design value. 

(defstruct blos-object
  (variables '())   ; alist: symbol -> value
  (procedures '())  ; alist: symbol -> procedure
  (parents '()))    ; list of blos-objects

;;;; ======================================================================
;;;;
;;;;                           WD (Word) struct
;;;;
;;;; ======================================================================


(defstruct wd
  "Internal representation of a Logo word."

  ;; Concrete surface form (syntax)
  (str "" :type string :read-only t)

  ;; Numeric interpretation or NIL (numeric semantics)
  (nmb nil :type (or number null) :read-only t)

  ;; Interned symbol or NIL (identifier semantics)
  (sym nil :type (or symbol null) :read-only t)

  ;; Creation / lexical context flags
  ;; Possible values: :quoted :thing :infix :barred ...
  (flags '() :type list :read-only t))

;;;; ======================================================================
;;;;
;;;;                           Infix struct
;;;;
;;;; ======================================================================

(defstruct infix
  (sign nil :type (or string null))     ; surface language
  (weight 0 :type number)        ; syntax-directed transformation (associativiy)
  (procedure nil :type (or proc null))) ; semantic core


;;;;  =====================================================================
;;;;
;;;;                   Logo's sequences: Lists and Arrays
;;;;
;;;;  =====================================================================

(defstruct (logo-list
            (:constructor %make-logo-list))
  (data '() :type list)
  (flatp nil :type boolean)       ;; true if known to be a sentence
  (origin :runtime :type symbol)) ;; :literal (constructed by reader |
                                  ;; :constructed | evaluated

(defstruct logo-array
  (data #() :type array)
  (origin 0 :type integer))


;;;;  =====================================================================
;;;;
;;;;                       Representational structs
;;;;
;;;;  =====================================================================


(defstruct rnode
  (kind nil :type symbol) ; :wd | :list | :array | :sep
  (value) ; atomic payload (words)
  (children '()  :type list) ; list of rnodes (can also be a value of rnode)
  (documentation "A presentation tree that answers the question: 'What *is* this thing?'"))

(defstruct print-context
  (list-style :bracket :type symbol) ;; :bracket | :bare
  (array-style :brace :type symbol)  ;; :brace | :bare
  (separator " " :type string)
  (stream nil :type symbol)
  (documentation "Answer to 'how should this thing be shown *right now*?'"))
