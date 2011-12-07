;;;; $Id$

(in-package #:image-info)

(defun check-gif-magic (stream)
  (let ((magic (make-array 6 :element-type '(unsigned-byte 8))))
    (let ((count (read-sequence magic stream)))
      (cond ((< count 6)
             (error "Short read when checking GIF magic"))
            ((not (starts-with #(71 73 70 56) magic))
             (error "Magic failed: ~S" magic))
            (t t)))))

(defun gif-dimensions (file)
  (with-open-file (stream file
                          :direction :input
                          :element-type '(unsigned-byte 8))
    (check-gif-magic stream)
    (values (read-uint16/lsb stream)
            (read-uint16/lsb stream))))
  