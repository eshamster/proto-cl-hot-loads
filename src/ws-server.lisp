(defpackage proto-cl-hot-loads.ws-server
  (:use :cl)
  (:export :*ws-app*
           :send-from-server)
  (:import-from :proto-cl-hot-loads.compiler
                :compile-ps-string)
  (:import-from :websocket-driver
                :make-server
                :on
                :send
                :start-connection
                :ready-state))
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
            (send-from-server ps-code)))
      (lambda (responder)
        (declare (ignore responder))
        (format t "~&Server connected")
        (start-connection server)))))

(defun send-from-server (ps-code)
  (let ((message (handler-case
                     (compile-ps-string ps-code)
                   (condition (e)
                     (declare (ignore e))
                     "alert(\"Compile Error!!\");"))))
    (dolist (server (copy-list *server-instance-list*))
      (case (ready-state server)
        (:open (send server message))
        (:closed (setf *server-instance-list* (remove server *server-instance-list*)))
        ;; otherwise do nothing
        ))))
