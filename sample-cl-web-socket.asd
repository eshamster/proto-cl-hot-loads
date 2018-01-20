#|
  This file is a part of sample-cl-web-socket project.
  Copyright (c) 2018 eshamster (hamgoostar@gmail.com)
|#

#|
  A sample of WebSocket in Common Lisp

  Author: eshamster (hamgoostar@gmail.com)
|#

(defsystem "sample-cl-web-socket"
  :version "0.1.0"
  :author "eshamster"
  :license "MIT"
  :depends-on (:websocket-driver-server
               :websocket-driver-client
               :clack
               :ningle
               :cl-markup
               :cl-ppcre
               :parenscript)
  :components ((:module "src"
                :serial t
                :components
                ((:file "ws-server")
                 (:file "static-server")
                 (:file "server")
                 (:file "utils")
                 (:file "sample-cl-web-socket"))))
  :description "A sample of WebSocket in Common Lisp"
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "sample-cl-web-socket-test"))))
