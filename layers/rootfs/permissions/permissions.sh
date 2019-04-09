#!/bin/bash


cat /permissions.list | while read perm
do

    if [[ "$perm" == "#"* ]] ; then
        continue
    else
        path=$(echo $perm | cut -d : -f1)
        type=$(echo $perm | cut -d : -f2)
        command=$(echo $perm | cut -d : -f3-)

        if [[ -z "$path" || -z "$command" ]]; then
            continue
        fi

        if [[ -z "$type" ]] ; then
            $command $path || true
        else
            find $path $type | xargs $command || true
        fi


    fi
done
