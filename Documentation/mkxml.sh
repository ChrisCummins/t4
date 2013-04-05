#!/bin/bash
# mkxml.sh - run `./mkxml.sh --help` for usage information.

export_prefix="dnl EXPORT"

print_usage() {
    echo "Usage: $(basename $0) <xml> <m4-file ...>"
    echo ""
    echo "Generate a file <xml> containing an xml tree of the"
    echo "set of m4 input files <m4-file ...>."
}

to_xml() {
    echo -e "$@" | sed 's/\&/\&amp;/g' | sed ':a;N;$!ba;s/\n/\&lt;br \/\&gt;/g' | sed 's/</\&lt;/g' | sed 's/>/\&gt;/g' | sed 's/["]/\&quot;/g'
}

xml_cat() {
    cat "$1" | sed 's/\&/\&amp;/g' | sed ':a;N;$!ba;s/\n/\&lt;br \/\&gt;/g' | sed 's/</\&lt;/g' | sed 's/>/\&gt;/g' | sed 's/["]/\&quot;/g'
}

if [ -z "$1" ] || [ -z "$2" ]; then
    print_usage
    exit 1
fi

case "$1" in
    "-h" | "--help" )
        print_usage
        exit 0
        ;;
esac

xml="$1"
shift

echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' > $xml

for file in $@; do
    test ! -f "$file" && { echo "file '$file' does not exist!" >&2; exit 1; }

    export_lines="$(grep -s -n -E "$export_prefix" "$file" | cut -d ':' -f1)"

    if [ -z "$export_lines" ]; then
        echo "warning: no exported definitions found in '$file'"
    fi

    pushd $(dirname "$file") > /dev/null
    path=`pwd`
    popd > /dev/null

    echo "<m4 file=\"$path/$(basename $file)\">" >> $xml

    for l in $export_lines; do
        linenum=$((l+1))
        line="$(sed -n "$linenum"p $file)"

        if [[ "$(sed -n "$l"p $file | grep '@var')" != "" ]]; then
            type="value"
        else
            type="proceedure"
        fi

        sed -n "$l"p $file | sed -r 's/\s*dnl\s+T4_EXPORT(\s+@var\s*)?//' > docs.comment.tmp
        while [[ "$(echo "$line" | grep -E '^\s*dnl')" != "" ]]; do
            echo $line | sed -r 's/\s*(dnl\s+)?//' >> docs.comment.tmp
            linenum=$((linenum+1))
            line="$(sed -n "$linenum"p $file)"
        done

        cat docs.comment.tmp | sed '/^$/d' | sed -r 's/^\s+//' | grep -v -E '^\s*@param\s+' > docs.comment.tmp.tmp
        mv -f docs.comment.tmp.tmp docs.desc.tmp

        cat docs.comment.tmp | grep -E '^\s*@param\s+' | sed -r 's/^\s*@param\s+//' > docs.param.tmp

        name="$(echo "$line" | sed -r 's/^\s*define\(\[//' | sed -r "s/\].+//")"

        sed -n "$linenum"p $file | sed -r 's/^\s*define\(\[//' | sed -r "s/[A-Za-z_0-9]+\]\s*,\s*//" > read.tmp
        cat "$file" | tail -n+$((linenum+1)) >> read.tmp

        echo '' > docs.exp.tmp
        depth=0
        while IFS= read l; do

            while IFS= read -n1 c; do
                if [[ $c == "[" ]]; then
                    depth=$((depth+1))
                fi

                if [[ $c == "]" ]]; then
                    depth=$((depth-1))

                    if [[ $depth = 0 ]]; then
                        break
                    fi
                fi

            done <<EOF
$l
EOF
            if [[ $depth = 0 ]]; then
                echo "$l" | sed -r 's/\]\),\s*\[\s*(dnl.*)?//' >> docs.exp.tmp
                break
            else
                echo "$l" >> docs.exp.tmp
            fi

        done < read.tmp

        echo "  <macro name=\"$(to_xml $name)\" type=\"$(to_xml $type)\" linum=\"$(to_xml $linenum)\">" >> $xml
        if [[ "$(cat docs.desc.tmp)" != "" ]]; then
            echo "    <description>\"$(xml_cat docs.desc.tmp)\"</description>" >> $xml
        fi
        while read p; do
            echo "    <parameter>$(to_xml $p)</parameter>" >> $xml
        done < docs.param.tmp
        echo "    <expansion>\"$(xml_cat docs.exp.tmp)\"</expansion>" >> $xml
        echo "  </macro>" >> $xml
    done

    echo "</m4>" >> $xml

    rm -f docs.exp.tmp
    rm -f docs.param.tmp
    rm -f docs.desc.tmp
    rm -f docs.comment.tmp
    rm -f read.tmp
done
