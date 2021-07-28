#!/bin/bash

# use quality 85 everywhere ... higher quality settings will automatically
# disable chroma subsampling for IM and libvips 

# some imagemagicks will never disable chroma subsample for this image, force
# it off
echo imagemagick, system libjpeg ...
convert pic.png \
  -quality 85 -interlace plane -strip -sampling-factor "2x2, 1x1, 1x1" \
  pic-imagick.jpg
ls -l pic-imagick.jpg

# basic libvips save options to match the above 
options="Q=85,optimize-coding,strip,interlace"

# the Q=85 one does nothing and will just match the imagic settings
for moz_option in Q=85 optimize-scans trellis-quant overshoot-deringing; do
  echo -n "libvips with mozjpeg --$moz_option ... "
  /usr/bin/time -f %e \
    docker run -t --rm -v $PWD:/data libvips-mozjpeg-buster \
      vipsthumbnail pic.png --size=1920x1280 \
        -o pic-mozjpeg-$moz_option.jpg[$options,$moz_option]
  ls -l "pic-mozjpeg-$moz_option.jpg"
done

