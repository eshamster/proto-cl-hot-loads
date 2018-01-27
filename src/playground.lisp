(defpackage proto-cl-hot-loads.playground
  (:use :cl
        :proto-cl-hot-loads.defines))
(in-package :proto-cl-hot-loads.playground)

(defvar.hl x 888)

(defonce.hl once 100)

(defun.hl my-log (text)
  ((ps:@ console log) text))

(with-hot-loads (:label sample)
  (my-log (+ x ": Hello Hot Loading!!")))
