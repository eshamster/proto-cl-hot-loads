(defpackage sample-cl-web-socket.compiler
  (:use :cl)
  (:export :compile-ps-string
           :convert-ps-s-expr-to-str
           :compile-ps-s-expr))
(in-package :sample-cl-web-socket.compiler)

;; "((defvar x 100) (incf x))"
(defun compile-ps-string (str-code)
  (macroexpand `(ps:ps ,(read-from-string
                         (concatenate 'string "(progn " str-code ")")))))

;; '((defvar x 100) (incf x))
(defun convert-ps-s-expr-to-str (body)
  (format nil "~W" `(progn ,@body)))

;; '((defvar x 100) (incf x))
(defun compile-ps-s-expr (body)
  (compile-ps-string (convert-ps-s-expr-to-str body)))
