#|
  This file is a part of sample-cl-web-socket project.
  Copyright (c) 2018 eshamster (hamgoostar@gmail.com)
|#

(defsystem "sample-cl-web-socket-test"
  :defsystem-depends-on ("prove-asdf")
  :author "eshamster"
  :license "MIT"
  :depends-on ("sample-cl-web-socket"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "sample-cl-web-socket"))))
  :description "Test system for sample-cl-web-socket"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
