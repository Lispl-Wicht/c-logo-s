(defsystem "c-logo-s"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "c-logo-s/tests"))))

(defsystem "c-logo-s/tests"
  :author ""
  :license ""
  :depends-on ("c-logo-s"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for c-logo-s"
  :perform (test-op (op c) (symbol-call :rove :run c)))
