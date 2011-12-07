This is image-info, a half-baked, undocumented library I wrote for
http://wigflip.com/ to get the type and dimensions of an incoming
image.

I'd really like to rewrite it into an extensible, clean library to
quickly find out useful info about a variety of image file formats.

In the meantime, though, this pile of stuff is what I have now.

Only supported function:

  (image-info:image-dimensions "image-file.png") => WIDTH, HEIGHT

For any questions or comments, please email me, Zach Beane
<xach@xach.com>.
