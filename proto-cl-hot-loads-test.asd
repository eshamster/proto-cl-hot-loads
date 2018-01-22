#|
  This file is a part of proto-cl-hot-loads project.
  Copyright (c) 2018 eshamster (hamgoostar@gmail.com)
|#

(defsystem "proto-cl-hot-loads-test"
  :defsystem-depends-on ("prove-asdf")
  :author "eshamster"
  :license "MIT"
  :depends-on ("proto-cl-hot-loads"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "proto-cl-hot-loads"))))
  :description "Test system for proto-cl-hot-loads"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
