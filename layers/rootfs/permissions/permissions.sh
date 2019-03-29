#!/bin/bash

cat /permissions.list | while read perm
do
    echo $perm

    if [[ "$perm" == "#"* ]] ; then
        echo comment
    else
        path=$(echo $perm | cut -d : -f1)
        type=$(echo $perm | cut -d : -f2)
        options=$(echo $perm | cut -d : -f3)
        mode=$(echo $perm | cut -d : -f4)

        [ -z "$options" ] && options=$options || options=-$options
        [ -z "$type" ] && type=$type || type="-type $type"

        if [[ $options =~ "R" ]] ; then
            echo "find $path $type | xargs chmod $options $mode"
            find $path $type | xargs chmod $options $mode || true
        else
            chmod $options $mode $path || true
        fi
    fi
done
