;;;; $Id: bitmap.lisp,v 1.1 2006/05/01 18:46:13 xach Exp $

(in-package #:image-info)

(defun check-magic (stream)
  (let ((magic1 (read-byte stream))
        (magic2 (read-byte stream)))
    (unless (and (= magic1 #x42)
                 (= magic2 #x4D))
      (error "Bad magic in BMP file"))))

(defun bitmap-stream-dimensions (stream)
  (check-magic stream)
  ;; skip unused bytes
  (file-position stream 18)
  (let ((width (read-uint32/lsb stream))
        (height (read-uint32/lsb stream)))
    (values width height)))

(defun bitmap-dimensions (file)
  (with-open-file (stream file
                   :direction :input
                   :element-type '(unsigned-byte 8))
    (ignore-errors (bitmap-stream-dimensions stream))))
    
