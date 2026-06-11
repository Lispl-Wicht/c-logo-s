(in-package #:logo)

;; Only a first skeleton:
(define-condition logo-error (error)
  ((code :initarg :code :reader logo-error-code)
   (message :initarg :message :reader logo-error-message)
   (recoverable :initarg :recoverable :initform nil)))

(define-condition logo-call-error (logo-error) ())
(define-condition logo-syntax-error (logo-error) ())
(define-condition logo-runtime-error (logo-error) ())

