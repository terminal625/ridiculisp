;;;; wotwot.lisp

(in-package #:wotwot)
;;below, () represents a single cons cell?
#+nil 
(((dest . ???) . ((src . ???) . ???)) . next)

(defclass konz ()
  ((kar :initarg kar :initform nil)
   (flip :initarg flip :initform nil)))

(defun konz (ze1 ze2)
  (let ((a (make-instance 'konz 'kar ze1))
	(d (make-instance 'konz 'kar ze2)))
    (setf (slot-value a 'flip) d)
    (setf (slot-value d 'flip) a)
    a))

(set-pprint-dispatch
 'konz
 (lambda (stream object)
   (write-char #\[ stream)
   (write (kar object) :stream stream)
   (write-char #\  stream)
   (write (kdr object) :stream stream)
   (write-char #\] stream)))

(defmethod kar ((k konz))
  (slot-value k 'kar))

(defmethod (setf kar) (new (k konz))
  (setf (slot-value k 'kar) new))

(defmethod kdr ((k konz))
  (slot-value (slot-value k 'flip) 'kar))

(defmethod (setf kar) (new (k konz))
  (setf (slot-value (slot-value k 'flip) 'kar) new))

(defun lizt (&rest args)
  (labels ((rec (list)
	     (if list
		 (konz (car list)
		       (rec (cdr list)))
		 nil)))
    (rec args)))

(defun konvert-tree-to-kons (tree)
  "convert a tree of cons cells into a kons tree. each list becomes a kons cell, 
with the first and second element becoming the kar and kdr respectively"
  (if tree
      (if (consp tree)
	  (konz (konvert-tree-to-kons (first tree))
		(konvert-tree-to-kons (second tree)))
	  tree)
      nil))

;;;(konvert-tree-to-kons '((234 234) (234 (234 234))))

;;;1 1 -> 0
;;;1 0 -> 1
;;;0 1 -> 1
;;;0 0 -> 0