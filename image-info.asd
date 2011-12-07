
(asdf:defsystem #:image-info
  :components ((:file "package")
	       (:file "utils"
		      :depends-on ("package"))
	       (:file "magic"
		      :depends-on ("package"))
	       (:file "jpeg"
		      :depends-on ("utils"))
	       (:file "gif"
		      :depends-on ("utils"))
	       (:file "png"
		      :depends-on ("utils"))
	       (:file "bitmap"
		      :depends-on ("utils"))
	       (:file "image-info"
		      :depends-on ("jpeg"
				   "gif"
				   "png"
				   "bitmap"))))
