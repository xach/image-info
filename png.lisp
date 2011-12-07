;;;; $Id$

(in-package #:image-info)

(defvar *png-signature* #(137 80 78 71 13 10 26 10))
(defvar *ihdr-signature* #(73 72 68 82))

(defun check-stream-sequence (stream sequence &optional error-text)
  (let ((input (make-array (length sequence)
                           :element-type '(unsigned-byte 8))))
    (read-sequence input stream)
    (unless (equalp input sequence)
      (error (or error-text "Input sequence mismatch")))))

(defun check-signature (stream)
  (check-stream-sequence stream *png-signature* "Bad PNG header"))

(defun check-ihdr (stream)
  (let ((length (read-uint32 stream)))
    (declare (ignore length))
    (check-stream-sequence stream *ihdr-signature* "Bad IHDR")))
        

(defun png-stream-dimensions (stream)
  (check-signature stream)
  (check-ihdr stream)
  (values (read-uint32 stream)
          (read-uint32 stream)))

(defun png-dimensions (file)
  (with-open-file (stream file
                          :direction :input
                          :element-type '(unsigned-byte 8))
    (ignore-errors (png-stream-dimensions stream))))





