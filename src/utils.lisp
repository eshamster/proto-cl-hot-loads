(defpackage sample-cl-web-socket.utils
  (:use :cl)
  (:export :create-js-file-if-required)
  (:import-from :sample-cl-web-socket.compiler
                :convert-ps-s-expr-to-str
                :compile-ps-s-expr)
  (:import-from :sample-cl-web-socket.ws-server
                :ws-client-started-p
                :send-from-client))
(in-package :sample-cl-web-socket.utils)

(defun send-ps-code (body)
  (when (ws-client-started-p)
    (send-from-client (convert-ps-s-expr-to-str body))))

(defstruct ps-def label def)
(defstruct ps-def-manager lst last-updated)

(defvar *ps-def-manager* (make-ps-def-manager))

(defun add-ps-def (label def)
  (check-type label symbol)
  (with-slots (lst last-updated) *ps-def-manager*
    (setf last-updated (get-universal-time))
    (let ((found (find-if
                  (lambda (ps-def) (eq label (ps-def-label ps-def)))
                  lst)))
      (if found
          (setf (ps-def-def found) def)
          (push (make-ps-def :label label :def def) lst)))))

(defun create-js-file-if-required (file-path)
  (check-type file-path pathname)
  (with-slots ((def-lst lst) last-updated) *ps-def-manager*
    (when (or (not (probe-file file-path))
              (< (file-write-date file-path) last-updated))
      (let ((dir (directory-namestring file-path)))
        (ensure-directories-exist dir)
        (with-open-file (file file-path
                              :direction :output
                              :if-exists :supersede
                              :if-does-not-exist :create)
          (dolist (def (reverse def-lst))
            (princ (compile-ps-s-expr (ps-def-def def)) file)
            (terpri file)))))))

(defmacro with-hot-loads ((&key label) &body body)
  `(progn (add-ps-def ',label ',body)
          (send-ps-code ',body)))

(defmacro defun.hl (name lambda-list &body body)
  `(with-hot-loads (:label ,name)
     (defun ,name ,lambda-list
       ,@body)))

(defmacro defvar.hl (var &optional val doc)
  `(with-hot-loads (:label ,var)
     (defvar ,var ,val ,doc)))

(defvar.hl x 888)

(defun.hl my-log (text)
  ((ps:@ console log) text))

(with-hot-loads (:label sample)
  (my-log (+ x ": Hello Hot Loading!!")))
