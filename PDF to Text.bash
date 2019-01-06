#!/bin/bash
echo "NOTIFICATION:Processed "$(basename "$@")
./pdftotext -layout "$@" -
