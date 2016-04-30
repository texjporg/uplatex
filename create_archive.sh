#!/bin/sh

PROJECT=uplatex-base
TMP=/tmp

git archive --format=tar --prefix=$PROJECT/ HEAD | (cd $TMP && tar xf -)

# Remove generated and auxiliary files
rm $TMP/$PROJECT/.gitignore
rm $TMP/$PROJECT/create_archive.sh
rm $TMP/$PROJECT/ukinsoku.tex
rm $TMP/$PROJECT/*.cls
rm $TMP/$PROJECT/*.clo
rm $TMP/$PROJECT/*.fd
ls $TMP/$PROJECT/*.ltx | grep -v uplpatch.ltx | xargs rm
rm $TMP/$PROJECT/*.sty

echo " * Create $PROJECT.zip"

PWDF=`pwd`
cd $TMP && zip -r $PWDF/$PROJECT.zip $PROJECT
rm -rf $TMP/$PROJECT
echo
echo " * Done: $PROJECT.zip"
