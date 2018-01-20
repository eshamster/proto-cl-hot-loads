(defpackage sample-cl-web-socket.utils
  (:use :cl)
  (:import-from :sample-cl-web-socket.ws-server
                :ws-client-started-p
                :send-from-client))
(in-package :sample-cl-web-socket.utils)

(defun send-ps-code (body)
  (when (ws-client-started-p)
    (send-from-client (format nil "~W" `(progn ,@body)))))

(defmacro with-hot-loads (() &body body)
  `(send-ps-code ',body))

(with-hot-loads ()
  (defun abcde (xxx)
    ((ps:@ console log) xxx)))

(with-hot-loads ()
  (abcde "Hello Hot Loading!!"))
