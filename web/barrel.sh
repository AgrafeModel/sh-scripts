#!/bin/bash

## [JS] [TS] [JSX] [TSX]
## This script creates index files for all directories in the current directory.
## The index file will export all files in the directory that have the same extension as the first extension passed as an argument to the script.
## The script will ignore directories that are passed as arguments to the --ignore flag.
## The script will also ignore directories that are subdirectories of the directories passed as arguments to the --ignore flag.


create_index() {
    local dir=$1
    local index_file="$dir/index"".${extensions[0]}"
    if [ -f "$index_file" ]; then
        echo "Deleting $index_file"
        rm "$index_file"
    fi

    echo "Creating $index_file"

    for file in "$dir"/*.${extensions[0]}; do
        if [[ "$(basename "$file")" != "index.${extensions[0]}" ]]; then
            filename=$(basename "$file" .ts)
            echo "export * from './$filename';" >> "$index_file"
        fi
    done
}


convert_to_absolute_path() {
    local path=$1
    if [[ "$path" == /* ]]; then
        echo "$path"
    else
        echo "$(cd "$path" && pwd)"
    fi
}

ignore_dirs=()
extensions=("ts")

while [[ "$#" -gt 0 ]]; do
### Parse parameters ###
    case $1 in
        --ignore)
            shift
            ignore_dirs+=("$(convert_to_absolute_path "$1")")
            ;;
        --js)
            extensions=("js")
            ;;

        --jsx)
            extensions=("jsx")
            ;;

        --ts)
            extensions=("ts")
            ;;

        --tsx)
            extensions=("tsx")
            ;;
        *)
            echo "Unknown parameter passed: $1"
            exit 1
            ;;

    esac
    shift
done


if [ ${#ignore_dirs[@]} -ne 0 ]; then
    echo "Ignoring directories:"
    for ignored in "${ignore_dirs[@]}"; do
        echo "$ignored"
    done
fi

echo "Extensions: ${extensions[@]}"
base_dir=$(pwd)

find "$base_dir" -type d | while read -r dir; do
    abs_dir=$(convert_to_absolute_path "$dir")
    ignore=false
    for ignored in "${ignore_dirs[@]}"; do
        if [[ "$abs_dir" == "$ignored"* ]]; then
            ignore=true
            break
        fi
    done

    if [ "$ignore" = false ]; then
        if ls "$dir"/{*.${extensions[0]}} 1> /dev/null 2>&1; then
            create_index "$dir"
        fi
    else
        echo "Skipping directory: $dir"
    fi
done

echo "All Barrels created successfully"
