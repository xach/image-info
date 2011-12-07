;;;; $Id$

(in-package #:image-info)

(defun read-uint32 (stream)
  (+ (ash (read-byte stream) 24)
     (ash (read-byte stream) 16)
     (ash (read-byte stream)  8)
     (ash (read-byte stream)  0)))

(defun read-uint16 (stream)
  (logand #xFFFF
          (logior (ash (read-byte stream) 8)
                  (ash (read-byte stream) 0))))

(defun read-uint32/lsb (stream)
  (+ (ash (read-byte stream)  0)
     (ash (read-byte stream)  8)
     (ash (read-byte stream) 16)
     (ash (read-byte stream) 24)))

(defun read-uint16/lsb (stream)
  (logand #xFFFF
          (logior (ash (read-byte stream) 0)
                  (ash (read-byte stream) 8))))

(defun starts-with (sequence1 sequence2 &key (test 'eql) (start 0))
  (when (>= (length sequence2) (length sequence1))
    (let ((mismatch (mismatch sequence1 sequence2 :test test :start2 start)))
      (or (not mismatch)
          (= mismatch (length sequence1))))))
