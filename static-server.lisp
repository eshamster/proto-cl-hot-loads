(defpackage proto-cl-hot-loads/static-server
  (:use :cl
        :cl-markup)
  (:export *static-app*))
(in-package :proto-cl-hot-loads/static-server)

(defvar *ningle-app* (make-instance 'ningle:<app>))

(setf (ningle:route *ningle-app* "/" :method :GET)
      (lambda (params)
        (declare (ignorable params))
        (with-output-to-string (str)
          (let ((cl-markup:*output-stream* str))
            (html5 (:head
                    (:title "A sample of WebSocket on Common Lisp")
                    (:script :src "js/hot_loads.js" nil)
                    (:script :src "js/main.js" nil))
                   (:body
                    (:div (:textarea :id "ps-code"
                                     :cols 80 :rows 10 "(alert \"Hello world!!\")"))
                    (:button :type "button" :onclick "send_ps_code()" "Send Parenscript code")
                    (:div (:textarea :id "js-code"
                                     :cols 80 :rows 10 :readonly t :disabled t nil))))))))

(defvar *static-app*
  (lack:builder
   (:static :path (lambda (path)
                    (if (ppcre:scan "^(?:/js/)" path)
                        path
                        nil))
            :root (merge-pathnames "src/"
                                   (asdf:component-pathname
                                    (asdf:find-system :proto-cl-hot-loads))))
   *ningle-app*))
