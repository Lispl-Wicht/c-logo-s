(asdf:defsystem "c-logo-s"
  :version "0.0.2"
  :author "Joachim Heller"
  :license "GPLv3"
  :depends-on ("str" "parse-number")
  ;;:serial t
  :components
  ((:module "src"
    :components
    ((:file "packages")
     (:file "structs" :depends-on ("packages"))
     (:file "top-vars-consts" :depends-on ("packages" "structs"))
     (:file "primitives" :depends-on ("packages" "structs" "top-vars-consts"))
     (:file "library" :depends-on ("packages" "structs" "top-vars-consts" "primitives"))
     (:file "raylib")
     (:file "graphics" :depends-on ("packages" "structs" "top-vars-consts" "primitives" "raylib"))
     (:file "sound" :depends-on ("packages" "structs" "top-vars-consts" "primitives"))
     (:file "turtle" :depends-on ("packages" "structs" "top-vars-consts" "primitives" "graphics" "sound"))
     (:file "reader" :depends-on ("packages" "structs" "top-vars-consts" "primitives"))
     (:file "logo" :depends-on ("packages" "structs" "top-vars-consts" "primitives" "library" "turtle")))))
  :description "The Common Lisp (Berkeley) Logo Setup. An implementation that at first hand aims to be fully compliant with Berkeley Logo 6.2 and the textbooks of Brian Harvey (1997/1984): Computer Science Logo Style (CSLS) Vol. 1-3.  Secondly, it should conform with Cynthia Solomon/Margaret Minsky/Brian Harvey (1986): LogoWorks, and also with the examples in Seymour Papert (1980): Mindstorms.")
  ;;:in-order-to ((test-op (test-op "c-logo-s/tests"))))
  ;; ;;:source-control (:git "https://github.com/Shinmera/parachute.git")
  ;;:build-operation "program-op"
  ;; ;;Alternatives
  ;; ;;:defsystem-depends-on (:deploy) ; library to deploy standalone cl apps
  ;; ;;:build-operation "deploy-op" ; regular case - for GUI applications
  ;; ;;:build-operation "deploy-console-op" ; for console applications
  ;; ;;:build-operation "deploy-image-op" ; creates a cl image
  ;;:build-pathname "bin/clogos"
  ;;:entry-point "c-logo-s:<main>" ; the function that ties everything together
  ;;(compile-op (load-op "<one-thing>" "<second-thing") ; load this
  ;;logo)) ; before compiling that)



#|(defsystem "c-logo-s/tests"
  :author "Joachim Heller"
  :license "GPLv3"
  :depends-on ("c-logo-s"
               "parachute")
  :serial t
  :components ((:module "tests"
                :components
                (:module "src"
                :components
                ((:file "packages")
                 (:file "conditions")
                 (:file "top-vars-consts")
                 (:file "structs")
                 (:file "primitives")
                 (:file "library")
                 (:file "raylib")
                 (:file "graphics")
                 (:file "sound")
                 (:file "turtle")
                 (:file "reader")
                 ;; main entry point:
                 (:file "logo")))))
  :description "Test system for c-logo-s"
  :perform (test-op (op c) (uiop:symbol-call :parachute :text :c))) ; replace :c|#

#+sb-core-compression
  (defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
    (uiop:dump-image (asdf:output-file o c)
                     :executable t
                     :compression t))

;; Tell ASDF to not update itself.      
;;(deploy:define-hook (:deploy asdf) (directory)
;;  (declare (ignorable directory))
;;  #+asdf (asdf:clear-source-registry)
;;  #+asdf (defun asdf:upgrade-asdf () nil))   
