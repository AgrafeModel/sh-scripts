#!/bin/bash

## This script generates a .h file from a .c file
## The .h file will contain the function prototypes and the imports from the .c file
## The .h file will have the same base name as the .c file
## The .h file will have include guards with the format <BASE_NAME>_H


# Check if a .c file is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <filename.c>"
    exit 1
fi

# Extract the base name of the file (without extension)
base_name=$(basename "$1" .c)
path=$(dirname "$1")


headername_uppercase="$(echo $base_name | tr '[:lower:]' '[:upper:]')"

# Create the .h file with the same base name
header_file="${path}/${base_name}.h"

echo "base_name: ${headername_uppercase}, path: $path"

# Add include guards to the .h file
echo "#ifndef ${headername_uppercase}_H" > "$header_file"
echo "#define ${headername_uppercase}_H" >> "$header_file"
echo "" >> "$header_file"


#get all the imports from the .c file
imports=$(grep -E "^#include" $1)

# Add the imports to the .h file
echo "$imports" >> "$header_file"
echo "" >> "$header_file"


# Add the function prototypes to the .h file
grep -E "^[a-zA-Z_].*\(" $1 | sed -E 's/\(.*\)/;/' >> "$header_file"
echo "" >> "$header_file"

# Close the include guards
echo "#endif // ${headername_uppercase}_H" >> "$header_file"

echo "Header file $header_file created successfully."
