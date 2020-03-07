#! /bin/bash

# Do the font dance with Source Pro (all of them)
# Adapted from: https://gist.github.com/jacksonpradolima/840b4a20c617204a65b15da61e124bf6

FONT_HOME="$HOME/.local/share/fonts"
mkdir -p $FONT_HOME/adobe
cd $FONT_HOME/adobe

echo "installing adobe fonts to $FONT_HOME/adobe"

wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip
unzip 1.050R-it.zip "*.otf"

wget https://github.com/adobe-fonts/source-serif-pro/archive/2.000R.zip
unzip 2.000R.zip "*.otf"

wget https://github.com/adobe-fonts/source-sans-pro/archive/2.020R-ro/1.075R-it.zip
unzip 1.075R-it.zip "*.otf"

fc-cache -f -v
