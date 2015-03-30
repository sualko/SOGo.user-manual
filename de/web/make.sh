#!/bin/bash

. make.cfg

# create pdf -s --toc
pandoc $INPUT -f markdown_github -o $OUTPUT.pdf  -c github-pandoc.css

# create html
pandoc $INPUT -f markdown_github -t html -o $OUTPUT.html -s --toc

# remove header
sed -i '1,/<body>/d' $OUTPUT.html

# remove footer
sed -i '/<\/body>/,$d' $OUTPUT.html

# add path to image src
sed -i "s/<img src=\"/<img src=\"$IMG_SRC/g" $OUTPUT.html

# add image style
sed -i "s/<img/<img style=\"$IMG_STYLE\"/g" $OUTPUT.html

# add path to link ref
sed -i "s/<a href=\"/<a href=\"$HREF/g" $OUTPUT.html

# add footer to html file
echo $HTML_FOOTER >> $OUTPUT.html
