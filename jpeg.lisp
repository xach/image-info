;;; No need to rely on external programs to find the dimensions of a
;;; JPEG; the format is specified in CCITT T.81 and is pretty easy to
;;; process for metadata.
;;;
;;; $Id: jpeg.lisp,v 1.3 2007/05/07 23:15:06 xach Exp $

(in-package #:image-info)

(defun standalone-marker-p (marker)
  ;; Table B.1
  (<= #xD0 marker #xD9))

(defun sof-marker-p (marker)
  ;; Table B.1
  (or (<= #xC0 marker #xC3)
      (<= #xC5 marker #xC7)
      (<= #xC9 marker #xCB)
      (<= #xCD marker #xCF)))

(defun skip-length (stream)
  (let ((length (read-uint16 stream)))
    (file-position stream (+ (file-position stream)
                             (- length 2)))))

(defun sofn-dimensions (stream)
  ;; Section B.2.2
  (let ((length (read-uint16 stream))
        (precision (read-byte stream))
        (height (read-uint16 stream))
        (width (read-uint16 stream)))
    (declare (ignore length precision))
    (values width height)))

(defun jpeg-stream-dimensions (stream)
  "Returns the WIDTH and HEIGHT of the frame in the JPEG stream STREAM
nas multiple values, or NIL if no frame is found."
  ;; Section B.1.1.2
  (do ((first-byte (read-byte stream nil) next-byte)
       (next-byte (read-byte stream nil) (read-byte stream nil)))
      ((not (and first-byte next-byte)))
    (when (and (= first-byte #xFF)
                (/= next-byte #xFF #x00))
      (cond ((sof-marker-p next-byte)
             (return (sofn-dimensions stream)))
            ((not (standalone-marker-p next-byte))
             (skip-length stream))))))

(defun jpeg-stream-p (stream)
  (and (eql (read-byte stream nil) #xFF)
       (eql (read-byte stream nil) #xD8)))

(defun jpeg-dimensions (file)
  "Returns the WIDTH and HEIGHT of the JPEG file FILE as multiple
values, or NIL if the file is not a valid JPEG file."
  (with-open-file (stream file
                   :direction :input
                   :element-type '(unsigned-byte 8))
    (when (jpeg-stream-p stream)
      (jpeg-stream-dimensions stream))))


#|
    > (time (jpeg-dimensions "/home/xach/rms-full-size.jpg"))

    Evaluation took:
      0.001 seconds of real time
      0.0 seconds of user run time
      0.0 seconds of system run time
      0 page faults and
      0 bytes consed.
    1536
    2048
|#
                  