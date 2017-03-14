#!/bin/bash
# rotoscope - auto rotoscope a video file
# with openSource Software on Linux
#
# needs mplayer, autotrace and ImageMagick
#
# usage: rotoscope videofile
# -- will create videofile.rotoscoped.avi
#
# created by Honza Svasek : HonzaSvasek.nl
#

export TMPDIR=/tmp/rotoscope$$
export FILM=$1
mkdir $TMPDIR
cd $TMPDIR
mplayer $FILM -nosound -vo jpeg
for FILE in *.jpg
do
echo $FILE
autotrace $FILE -output-format svg \
-color-count 10 \
-despeckle-level 20 \
-filter-iterations 10 > ${FILE}.svg
rm $FILE
convert ${FILE}.svg $FILE
done
mencoder 'mf://*jpg' -ovc lavc \
-o $FILM.rotoscoped.avi
cd ..
rm -f $TMPDIR
mplayer $FILM.rotoscoped.avi 
