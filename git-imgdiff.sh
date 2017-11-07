#!/bin/bash

DIFF_PATH=/tmp/diff.png
MONTAGE_PATH=/tmp/montage.png
rm -rf $DIFF_PATH $MONTAGE_PATH

# This script will be called for removed images as well so we just noop for that
# case.
if [ ! -f "$1" ]; then
  exit 0
fi

# Try to diff the images and create a montage with the original on
# the left, diff in the middle and the new one on the right.
DIFF=$(compare "$2" "$1" png:- > $DIFF_PATH)

# XXX: for some reason IG exits with 1 when it successfully creates the diff
if [[ $? == 1 ]]; then
  montage -label Original "$2" -label Diff $DIFF_PATH -label New "$1" \
    -tile x1 -geometry '433x+4+4>' $MONTAGE_PATH
else
  # If the images have different sizes the diff will fail.
  # In this case, create a montage with just the original and the new one.
  montage -label Original "$2" -label New "$1" \
    -tile x1 -geometry '650x+4+4>' $MONTAGE_PATH
fi

if [[ $? == 0 ]]; then
  display $MONTAGE_PATH> /dev/null 2>&1
fi
