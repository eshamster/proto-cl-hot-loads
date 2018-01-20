(defpackage sample-cl-web-socket.server
  (:use :cl)
  (:export :start
           :stop

           :server-started-p
           :get-server-port
           :add-server-stop-hook)
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
(defvar *port* nil)

(defun server-started-p ()
  (not (null *server*)))

(defun get-server-port ()
  *port*)

(defun start (&key (port 5000))
  (stop)
  (setf *port* port
        *server*
        (clack:clackup
         (lack:builder *mv* *static-app*)
         :port port)))

(defvar *server-stop-hooks* nil)

(defun add-server-stop-hook (callback)
  (pushnew callback *server-stop-hooks*))

(defun stop ()
  (when *server*
    (dolist (hook *server-stop-hooks*)
      (funcall hook))
    (clack:stop *server*)
    (setf *server* nil
          *port* nil)))
