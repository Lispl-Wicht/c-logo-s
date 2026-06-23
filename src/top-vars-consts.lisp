(in-package #:logo)

;; What is truth in Logo?
(defconstant +logo-true+ 'true)
(defconstant +logo-false+ 'false)

;; What can be executed?
(defvar *primitive-obarray* (make-hash-table :test 'equal))
(defvar *library-obarray*   (make-hash-table :test 'equal))
(defvar *workspace-obarray* (make-hash-table :test 'equal))

;; What can be talked about?
(defvar *glossary-table* (make-hash-table :test 'equal))

;; What are syntactic keywords?
(defparameter *syntkeys* #|(let ((ht (make-hash-table :test #'equal)))
                           (dolist (skw '("with" "end" "usual"))
                             (setf (gethash skw ht) t))
                           ht)|#
                          '("with" "end" "usual"))

;; How is the output structured?
(defparameter *show-context*
  (make-print-context :list-style :bracket
                      :array-style :brace
                      :separator " "))
                      
(defparameter *print-context*
  (make-print-context :list-style :bare
                      :array-style :brace
                      :separator " "))

;; What does the surface convenience mean?
(defparameter *infix-table* (make-hash-table :test 'equal))
(defparameter *workspace-infix-table* (make-hash-table :test 'equal))
