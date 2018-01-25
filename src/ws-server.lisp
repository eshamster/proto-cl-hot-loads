(defpackage proto-cl-hot-loads.ws-server
  (:use :cl)
  (:export :*ws-app*
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
                :make-client
                :ready-state)
  (:import-from :clack
                :clackup
                :stop))
(in-package :proto-cl-hot-loads.ws-server)

;; --- server --- ;;

(defvar *server-instance-list* nil)

(defparameter *ws-app*
  (lambda (env)
    (let ((server (make-server env)))
      (push server *server-instance-list*)
      (on :message server
          (lambda (ps-code)
            (format t "~&Server got: ~A~%" ps-code)
            (send-from-server
             (handler-case
                 (compile-ps-string ps-code)
               (condition (e)
                 (declare (ignore e))
                 "alert(\"Compile Error!!\");")))))
      (lambda (responder)
        (declare (ignore responder))
        (format t "~&Server connected")
        (start-connection server)))))

(defun send-from-server (message)
  (dolist (server (copy-list *server-instance-list*))
    (case (ready-state server)
      (:open (send server message))
      (:closed (setf *server-instance-list* (remove server *server-instance-list*)))
      ;; otherwise do nothing
      )))

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
