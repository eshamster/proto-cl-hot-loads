(defpackage proto-cl-hot-loads.server
  (:use :cl)
  (:export :start
           :stop
           :server-started-p)
  (:import-from :proto-cl-hot-loads.static-server
                :*static-app*)
  (:import-from :proto-cl-hot-loads.ws-server
                :*ws-app*
                :start-ws-client
                :stop-ws-client)
  (:import-from :proto-cl-hot-loads.utils
                :create-js-file-if-required))
(in-package :proto-cl-hot-loads.server)

(defparameter *mv*
  (lambda (app)
    (lambda (env)
      (create-js-file-if-required
       (merge-pathnames "src/js/main.js"
                        (asdf:component-pathname
                         (asdf:find-system :proto-cl-hot-loads))))
      (let ((uri (getf env :request-uri)))
        (if (string= uri "/ws")
            (funcall *ws-app* env)
            (funcall app env))))))

(defvar *server* nil)
(defvar *port* nil)

(defun server-started-p ()
  (not (null *server*)))

(defun start (&key (port 5000))
  (stop)
  (setf *port* port
        *server*
        (clack:clackup
         (lack:builder *mv* *static-app*)
         :port port))
  (start-ws-client :port port))

(defun stop ()
  (when *server*
    (stop-ws-client)
    (clack:stop *server*)
    (setf *server* nil
          *port* nil)))
