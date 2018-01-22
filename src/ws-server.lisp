(defpackage proto-cl-hot-loads.ws-server
  (:use :cl)
  (:export :*ws-app*
           :start-ws-server
           :stop-ws-server
           :send-from-server

           :start-ws-client
           :stop-ws-client
           :send-from-client
           :ws-client-started-p)
  (:import-from :proto-cl-hot-loads.compiler
                :compile-ps-string)
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
(in-package :proto-cl-hot-loads.ws-server)

;; --- server --- ;;

(defvar *server-instance* nil)

(defparameter *ws-app*
  (lambda (env)
    (setf *server-instance* (make-server env))
    (on :message *server-instance*
        (lambda (ps-code)
          (format t "~&Server got: ~A~%" ps-code)
          (send *server-instance*
                (handler-case
                    (compile-ps-string ps-code)
                  (condition (e)
                    (declare (ignore e))
                    "alert(\"Compile Error!!\");")))))
    (lambda (responder)
      (declare (ignore responder))
      (format t "~&Server connected")
      (start-connection *server-instance*))))

(defvar *ws-server* nil)

(defun start-ws-server (&key port)
  (assert port)
  (stop-ws-server)
  (setf *ws-server*
        (clackup *ws-app* :port port)))

(defun stop-ws-server ()
  (when *ws-server*
    (stop *ws-server*)
    (setf *ws-server* nil)))

(defun send-from-server (message)
  (send *server-instance* message))

;; --- client --- ;;

(defvar *client-instance* nil)

(defun ws-client-started-p ()
  (not (null *client-instance*)))

(defun start-ws-client (&key port)
  (assert port)
  (stop-ws-client)
  (setf *client-instance* (make-client (format nil "ws://localhost:~A/ws" port)))
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
