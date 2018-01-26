(defpackage proto-cl-hot-loads.middleware
  (:use :cl)
  (:export :make-hot-load-middleware)
  (:import-from :proto-cl-hot-loads.ws-server
                :*ws-app*)
  (:import-from :proto-cl-hot-loads.utils
                :create-js-file-if-required))
(in-package :proto-cl-hot-loads.middleware)

(defun make-hot-load-middleware (&key main-js-path string-url)
  (lambda (app)
    (lambda (env)
      (create-js-file-if-required main-js-path)
      (let ((uri (getf env :request-uri)))
        (if (string= uri string-url)
            (funcall *ws-app* env)
            (funcall app env))))))
