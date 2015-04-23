#!/bin/bash

. make.cfg

# create and clean build directory
mkdir -p build/
rm -r build/*

# copy dependencies
cp -R img/ build/
cp github-pandoc.css build/

# replace variables
cp $INPUT build/
sed -i "s/{IMAP_HOST}/${IMAP_HOST}/g" build/$INPUT
sed -i "s/{SMTP_HOST}/${SMTP_HOST}/g" build/$INPUT
sed -i "s/{SOGO_URL}/${SOGO_URL}/g" build/$INPUT

# create pdf -s --toc
pandoc build/$INPUT -f markdown_github -o build/$OUTPUT.pdf -s --toc

# create standalone html
pandoc build/$INPUT -f markdown_github -t html -o build/$OUTPUT-standalone.html -s --toc -c github-pandoc.css

# create html
pandoc build/$INPUT -f markdown_github -t html -o build/$OUTPUT.html -s --toc

# remove header
sed -i '1,/<body>/d' build/$OUTPUT.html

# remove footer
sed -i '/<\/body>/,$d' build/$OUTPUT.html

# add path to image src
sed -i "s/<img src=\"/<img src=\"$IMG_SRC/g" build/$OUTPUT.html

# add image style
sed -i "s/<img/<img style=\"$IMG_STYLE\"/g" build/$OUTPUT.html

# add path to link ref
sed -i "s/<a href=\"/<a href=\"$HREF/g" build/$OUTPUT.html

# add footer to html file
echo $HTML_FOOTER >> build/$OUTPUT.html

rm build/$INPUT
