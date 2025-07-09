#!/usr/bin/env bash
#

LANGS="zh_CN en zh_Hant"

function init_message() {
    find . -iname "*.sh" | xargs  xgettext --output=/tmp/giraffejump-installer.pot --from-code=UTF-8

    for lang in $LANGS; do
        mkdir -p locale/${lang}/LC_MESSAGES
        msginit --input=/tmp/giraffejump-installer.pot --locale=locale/${lang}/LC_MESSAGES/giraffejump-installer.po
    done
}

function make_message() {
    find . -iname "*.sh" | xargs  xgettext --output=/tmp/giraffejump-installer.pot --from-code=UTF-8

    for lang in $LANGS; do
        msginit --input=/tmp/giraffejump-installer.pot --locale=locale/${lang}/LC_MESSAGES/giraffejump-installer-tmp.po
        msgmerge -U locale/${lang}/LC_MESSAGES/giraffejump-installer-tmp.po /tmp/giraffejump-installer.pot
    done

    for lang in $LANGS; do
        rm -f locale/${lang}/LC_MESSAGES/giraffejump-installer-tmp.po
        rm -f locale/${lang}/LC_MESSAGES/giraffejump-installer.po\~
    done
}

function compile_message() {
    for lang in $LANGS; do
        msgfmt --output-file=locale/${lang}/LC_MESSAGES/giraffejump-installer.mo locale/${lang}/LC_MESSAGES/giraffejump-installer.po
    done
}

action=$1
if [ -z "$action" ]; then
    action="make"
fi

case $action in
    m|make)
        make_message;;
    i|init)
        init_message;;
    c|compile)
        compile_message;;
    *)
        echo "Usage: $0 [m|make i|init | c|compile]"
        exit 1
        ;;
esac
