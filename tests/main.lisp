(defpackage c-logo-s/tests/main
  (:use :cl
        :c-logo-s
        :rove))
(in-package :c-logo-s/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :c-logo-s)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
