
(in-package #:image-info)

(defparameter *magic*
  '((#(71 73 70) . :GIF)
    (#(137 80 78 71) . :PNG)
    (#(255 216) . :JPG)
    (#(66 77) . :BMP)))

(defun first-eight-octets (file)
  (with-open-file (stream file
                   :direction :input
                   :element-type '(unsigned-byte 8))
    (let ((bytes (make-array 8 :element-type '(unsigned-byte 8)
                             :initial-element 0)))
      (read-sequence bytes stream)
      bytes)))

(defun magic-guess (bytes)
  (loop for ((magic . type)) on *magic*
        when (starts-with magic bytes)
        return type
        finally (return :unknown)))

(defun magic (file)
  (magic-guess (first-eight-octets file)))

