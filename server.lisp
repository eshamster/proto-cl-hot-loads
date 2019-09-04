(defpackage proto-cl-hot-loads/server
  (:use :cl)
  (:export :start
           :stop
           :server-started-p)
  (:import-from :proto-cl-hot-loads/static-server
                :*static-app*)
  (:import-from :proto-cl-hot-loads/middleware
                :make-hot-load-middleware))
(in-package :proto-cl-hot-loads/server)

(defvar *server* nil)
(defvar *port* nil)

(defun server-started-p ()
  (not (null *server*)))

(defun start (&key (port 5000) (address "0.0.0.0"))
  (stop)
  (setf *port* port
        *server*
        (clack:clackup
         (lack:builder
          (make-hot-load-middleware
           :main-js-path (merge-pathnames
                          "src/js/main.js"
                          (asdf:component-pathname
                           (asdf:find-system :proto-cl-hot-loads)))
           :string-url "/ws")
          *static-app*)
         :port port
         :address address)))

(defun stop ()
  (when *server*
    (clack:stop *server*)
    (setf *server* nil
          *port* nil)))
