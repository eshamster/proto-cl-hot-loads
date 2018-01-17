(defpackage sample-cl-web-socket.server
  (:use :cl)
  (:export :start
           :stop)
  (:import-from :sample-cl-web-socket.static-server
                :*static-app*)
  (:import-from :sample-cl-web-socket.ws-server
                :*ws-app*))
(in-package :sample-cl-web-socket.server)

(defparameter *mv*
  (lambda (app)
    (lambda (env)
      (let ((uri (getf env :request-uri)))
        (if (string= uri "/ws")
            (funcall *ws-app* env)
            (funcall app env))))))

(defvar *server* nil)

(defun start (&key (port 5000))
  (stop)
  (setf *server*
        (clack:clackup
         (lack:builder *mv* *static-app*)
         :port port)))

(defun stop ()
  (when *server*
    (clack:stop *server-instance*)
    (setf *server-instance* nil)))
