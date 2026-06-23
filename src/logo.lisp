(in-package #:logo)
(defun step-pipeline (logo-str)
  (step
   (group-expressions-in-document
    (replace-first-order-proc-words-in-document
     (replace-infix-in-document
      (minus-sanity-check-in-document
       (decontract-infix-words-in-document
        (flag-lexical-bindings-in-document
         (flag-scope-introducer-in-document
          (verbalize-document
           (build-complexes-in-document
            (normalize-minus-in-tree
             (check-structural-balance
              (repair-bars
               (tokenize-segments
                (number-lines
                 (preserve-comments
                  (construct-lines
                   (continue-lines logo-str))))))))))) ))))))))

(in-package #:logo/workspace)


