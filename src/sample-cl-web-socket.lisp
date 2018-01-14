(defpackage sample-cl-web-socket
  (:use :cl)
  (:export :start-ws-server 
           :stop-ws-server
           :send-from-server

           :start-ws-client
           :stop-ws-client
           :send-from-client)
  (:import-from :websocket-driver
                :make-server
                :on
                :send
                :start-connection
                :close-connection
                :make-client)
  (:import-from :clack
                :clackup
                :stop))
(in-package :sample-cl-web-socket)

;; --- server --- ;;

(defvar *server-instance* nil)

(defparameter *ws-server*
  (lambda (env)
    (setf *server-instance* (make-server env))
    (on :message *server-instance*
        (lambda (message)
          (format t "~&Server got: ~A~%" message)
          (send *server-instance* message))) 
    (lambda (responder)
      (declare (ignore responder))
      (format t "~&Server connected")
      (start-connection *server-instance*))))

(defvar *server-app* nil)

(defun start-ws-server (&key port)
  (assert port)
  (stop-ws-server)
  (setf *server-app*
        (clackup *ws-server* :port port)))

(defun stop-ws-server ()
  (when *server-app*
    (stop *server-app*)
    (setf *server-app* nil)))

(defun send-from-server (message)
  (send *server-instance* message))

;; --- client --- ;;

(defvar *client-instance* nil)

(defun start-ws-client (&key port)
  (assert port)
  (stop-ws-client)
  (setf *client-instance* (make-client (format nil "wss://localhost:~A/sample" port)))
  (start-connection *client-instance*)
  (on :message *client-instance*
      (lambda (message)
        (format t "~&Client got: ~A~%" message))))

(defun stop-ws-client ()
  (when *client-instance*
    (close-connection *client-instance*)
    (setf *client-instance* nil)))

(defun send-from-client (message)
  (send *client-instance* message))
