#!/bin/bash

# configure languages
LANGUAGES='ar cs da de es fr hi it pl pt ru sv uk zh jp'

# configure locations, don't incude the final slash
SOURCEDOCDIR=$HOME/Local/github/Ghini/ghini.desktop/doc
CHECKOUTDIR=$HOME/Local/github/Ghini/ghini.desktop-docs.i18n
ALLPODIR=$CHECKOUTDIR/po

# "all remaining actions must be run from the doc dir"
cd $CHECKOUTDIR/doc

echo '=========================================================================='
echo "copy/update files from the documentation"
echo '--------------------------------------------------------------------------'
cp -pu $SOURCEDOCDIR/*.rst .
rm api.rst
echo "done copying/updating files from documentation"
echo '--------------------------------------------------------------------------'
echo
echo '=========================================================================='
echo "update the centralised doc.pot (prepare all pot, merge them, filter)"
echo '--------------------------------------------------------------------------'
echo "update the centralised doc.pot --- step one"
echo '--------------------------------------------------------------------------'
make gettext
echo "update the centralised doc.pot --- step two and three"
echo '--------------------------------------------------------------------------'
msgcat _build/locale/*.pot | msggrep --msgid --file not_to_be_translated.txt --invert-match -o _build/locale-merged/doc.pot
echo "done updating centralised doc.pot"
echo '--------------------------------------------------------------------------'
echo
echo '=========================================================================='
echo "update all LANGUAGE/doc.po files in CHECKOUTDIR/local/"
echo '--------------------------------------------------------------------------'
sphinx-intl update -p _build/locale-merged $(for i in $LANGUAGES; do printf -- '-l %s ' $i; done)

echo '=========================================================================='
echo "make sure we have all the symbolic links for po files"
echo '--------------------------------------------------------------------------'
for l in $LANGUAGES
do
    cd $CHECKOUTDIR/locale/$l/LC_MESSAGES/
    for i in $(find $CHECKOUTDIR/doc -maxdepth 1 -type f -name "*rst")
    do
        ln -s doc.po $(basename $i .rst).po 2>/dev/null
    done
    cd $ALLPODIR
    ln -s ../locale/$l/LC_MESSAGES/doc.po $l.po 2>/dev/null
done

echo "done updating po files and symbolic links"
echo '--------------------------------------------------------------------------'
echo
echo '=========================================================================='
echo "this is enough as far as weblate and readthedocs are concerned"
echo '--------------------------------------------------------------------------'
#################################################################
echo press enter to continue with other stuff, or ^C to stop here
read

#################################################################
# build translated documentation for all configured languages

# 1) update mo files from symlinks to doc.po.
sphinx-intl build

# 2) use the updated mo files to build the local html files
for i in $LANGUAGES
do
    make -e SPHINXOPTS="-D language='"$i"'" html
    mkdir -p ../translated/$i
    cp -a _build/html ../translated/$i
done
