#!/bin/bash

SEARCH_DIR="${1:-.}"
LOGFILE="$(pwd)/failure.log"
> "$LOGFILE" # Clear the log file at the start

while IFS= read -r tf_file; do
    dir=$(dirname "$tf_file")
    echo "Processing directory: $dir"

    # Move into the directory containing main.tf
    pushd "$dir" >/dev/null || continue

    if ! terraform init -no-color; then
        echo "Terraform init failed in $dir" | tee -a "$LOGFILE"
        popd >/dev/null
        continue
    fi

    if ! terraform validate -no-color; then
        echo "Terraform validate failed in $dir" | tee -a "$LOGFILE"
        popd >/dev/null
        continue
    fi

    if [ -f ".ignore_plan" ]; then
        echo "Skipping terraform plan in $dir because .ignore_plan file is present"
    else
        if ! terraform plan -no-color; then
            echo "Terraform plan failed in $dir" | tee -a "$LOGFILE"
            popd >/dev/null
            continue
        fi
    fi

    echo "All checks passed for $dir"

    # Return to the previous directory
    popd >/dev/null

done < <(find "$SEARCH_DIR" -type f -name main.tf)

echo "Script complete. Any failures were logged in $LOGFILE."
