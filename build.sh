#!/bin/bash
set -e

if [ "$1" != "" ]; then
    printf "Building Docs for Languge '$1'...\n\n"
    LANG="$1"
else
    printf "Languge not specified, using the default one 'en'...\n\n"
    LANG="en"
fi

sphinx-build -b gettext . _build/gettext
sphinx-intl update -p _build/gettext -l $LANG
sphinx-build -T -E -d _build/doctrees-readthedocs -D language=$LANG . _build/html/$LANG
