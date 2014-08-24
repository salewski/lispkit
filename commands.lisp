(in-package :lispkit)

;; TODO make this a hash-table
(defparameter *available-commands* nil)
(defparameter *cancel-functions*   nil)

(defclass command ()
  ((name :initarg :name :accessor name)
   (implementation :initarg :impl :accessor impl)
   (documentation :initarg :doc :accessor doc)))

(define-condition command-documentation-warning (style-warning)
  ((name :initarg :name :reader name))
  (:report
   (lambda (condition stream)
     (format stream
             "Command ~A doesn't have a documentation string"
             (name condition)))))

(defmacro defcommand (name arglist &body body)
  (let ((documentation (if (stringp (first body))
                           (first body)
                           (warn (make-condition 'command-documentation-warning
                                                 :name name))))
        (body (if (stringp (first body))
                  (rest body)
                  body)))
      `(make-instance 'command
                   :name (symbol-name ',name)
                   :impl #'(lambda ,arglist
                             ,@body)
                   :doc ,documentation)))
(defmacro defcancel (name arglist &body body)
  `(progn
     (defun ,name ,arglist ,@body)
     (push #',name *cancel-functions*)))

(defmethod initialize-instance :after ((command command) &key)
  (with-slots (name) command
    (setq *available-commands*
          (remove-if #'(lambda (other-command)
                         (equalp name (name other-command))) *available-commands*)))
  (push command *available-commands*))

(defun command-match (name? command)
  (with-slots (name) command
    (equalp name name?)))

(defun command-p (name)
  (member name *available-commands* :test #'command-match))

(defun run-named-command (name browser)
  (let ((command (command-p name)))
    (when command
      (with-slots (implementation) (first command)
        (funcall implementation browser)))))
