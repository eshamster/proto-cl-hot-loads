#|
  This file is a part of proto-cl-hot-loads project.
  Copyright (c) 2018 eshamster (hamgoostar@gmail.com)
|#

#|
  A sample of WebSocket in Common Lisp

  Author: eshamster (hamgoostar@gmail.com)
|#

(defsystem "proto-cl-hot-loads"
  :version "0.1.0"
  :author "eshamster"
  :class :package-inferred-system
  :defsystem-depends-on (:asdf-package-system)
  :license "MIT"
  :depends-on (:websocket-driver-server
               :websocket-driver-client
               :clack
               :ningle
               :cl-markup
               :cl-ppcre
               :parenscript
               :proto-cl-hot-loads/main
               :proto-cl-hot-loads/playground)
  :description "A sample of WebSocket in Common Lisp"
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "proto-cl-hot-loads-test"))))
