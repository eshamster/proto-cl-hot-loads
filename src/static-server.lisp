(defpackage sample-cl-web-socket.static-server
  (:use :cl
        :cl-markup)
  (:export *static-app*)
  (:import-from :sample-cl-web-socket.ws-server
                :start-ws-server
                :stop-ws-server))
(in-package :sample-cl-web-socket.static-server)

(defvar *static-app* (make-instance 'ningle:<app>))

(setf (ningle:route *static-app* "/" :method :GET)
      (lambda (params)
        (declare (ignorable params))
        (with-output-to-string (str)
          (let ((cl-markup:*output-stream* str))
            (html5 (:head
                    (:title "A sample of WebSocket on Common Lisp"))
                   (:body
                    (:div :id "test" "test")))))))
