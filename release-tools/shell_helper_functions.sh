#!/bin/sh -ex

# These functions are a collection of items from my shell history used to verify/generate releases.
# This "script" has no intended function other than to provide sufficient hints for syntax highlighting to editors

# Provide a print out of all provided hashes with their respective types
for source_hash in $(find . -type f -name '*-source-release.zip.*' | grep -v asc); do
  type=$(echo $source_hash | cut -d '.' -f '6' | tr /a-z/ /A-Z/)
  echo $type: $(cat $source_hash)
done
