#!/bin/sh

PROJECT=uplatex
TMP=/tmp
PWDF=`pwd`
RELEASEDATE=`git tag | sort -r | head -n 1`

echo " * Create $PROJECT.tds.zip"
git archive --format=tar --prefix=$PROJECT/ HEAD | (cd $TMP && tar xf -)
rm $TMP/$PROJECT/.gitignore
rm $TMP/$PROJECT/create_archive.sh
perl -pi.bak -e "s/\\\$RELEASEDATE/$RELEASEDATE/g" $TMP/$PROJECT/README.md
rm -f $TMP/$PROJECT/README.md.bak

mkdir -p $TMP/$PROJECT/doc/uplatex/base
mv $TMP/$PROJECT/LICENSE $TMP/$PROJECT/doc/uplatex/base/
mv $TMP/$PROJECT/README.md $TMP/$PROJECT/doc/uplatex/base/
mv $TMP/$PROJECT/*.pdf $TMP/$PROJECT/doc/uplatex/base/
mv $TMP/$PROJECT/*.txt $TMP/$PROJECT/doc/uplatex/base/

mkdir -p $TMP/$PROJECT/source/uplatex/base
mv $TMP/$PROJECT/Makefile $TMP/$PROJECT/source/uplatex/base/
cp $TMP/$PROJECT/uplpatch.ltx $TMP/$PROJECT/source/uplatex/base/
mv $TMP/$PROJECT/*.dtx $TMP/$PROJECT/source/uplatex/base/
mv $TMP/$PROJECT/*.ins $TMP/$PROJECT/source/uplatex/base/

mkdir -p $TMP/$PROJECT/tex/uplatex/base
mv $TMP/$PROJECT/ukinsoku.tex $TMP/$PROJECT/tex/uplatex/base/
mv $TMP/$PROJECT/*.clo $TMP/$PROJECT/tex/uplatex/base/
mv $TMP/$PROJECT/*.cls $TMP/$PROJECT/tex/uplatex/base/
mv $TMP/$PROJECT/*.fd  $TMP/$PROJECT/tex/uplatex/base/
mv $TMP/$PROJECT/*.ltx $TMP/$PROJECT/tex/uplatex/base/
mv $TMP/$PROJECT/*.sty $TMP/$PROJECT/tex/uplatex/base/

mkdir -p $TMP/$PROJECT/tex/uplatex/config
mv $TMP/$PROJECT/uplatex.ini $TMP/$PROJECT/tex/uplatex/config/

cd $TMP/$PROJECT && zip -r $TMP/$PROJECT.tds.zip *
cd $PWDF
rm -rf $TMP/$PROJECT

echo
echo " * Create $PROJECT.zip ($RELEASEDATE)"
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
perl -pi.bak -e "s/\\\$RELEASEDATE/$RELEASEDATE/g" $TMP/$PROJECT/README.md
rm -f $TMP/$PROJECT/README.md.bak
mv $TMP/$PROJECT.tds.zip $TMP/$PROJECT/

cd $TMP && zip -r $PWDF/$PROJECT.zip $PROJECT
rm -rf $TMP/$PROJECT
echo
echo " * Done: $PROJECT.zip ($RELEASEDATE)"
