
(in-package #:image-info)

(defun image-dimensions (file)
  (let* ((bytes (first-eight-octets file))
         (magic (magic-guess bytes)))
    (case magic
      (:jpg (jpeg-dimensions file))
      (:gif (gif-dimensions file))
      (:bmp (bitmap-dimensions file))
      (:png (png-dimensions file)))))

