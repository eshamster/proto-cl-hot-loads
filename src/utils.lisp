(defpackage sample-cl-web-socket.utils
  (:use :cl)
  (:import-from :sample-cl-web-socket.ws-server
                :start-ws-client
                :stop-ws-client
                :ws-client-started-p
                :send-from-client)
  (:import-from :sample-cl-web-socket.server
                :server-started-p
                :get-server-port
                :add-server-stop-hook))
(in-package :sample-cl-web-socket.utils)

(add-server-stop-hook
 (lambda ()
   (when (ws-client-started-p)
     (stop-ws-client))))

(defun try-to-start-client ()
  (when (server-started-p)
    (start-ws-client :port (get-server-port))))

(defun send-ps-code (body)
  (unless (ws-client-started-p)
    (try-to-start-client))
  (when (ws-client-started-p)
    (send-from-client (format nil "~W" `(progn ,@body)))))

(defmacro with-hot-loads (() &body body)
  `(send-ps-code ',body))

(with-hot-loads ()
  (defun abcde (xxx)
    ((ps:@ console log) xxx)))

(with-hot-loads ()
  (abcde "Hello Hot Loading!!"))
