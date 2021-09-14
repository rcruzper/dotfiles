#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Generate UUID
# @raycast.mode silent
# @raycast.packageName Developer Utilities

# Optional parameters:
# @raycast.icon 💻

# Documentation:
# @raycast.description Generates a UUID and copies it to the clipboard.
# @raycast.author Raúl Cruz
# @raycast.authorURL https://github.com/rcruzper

uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\n' | pbcopy
echo "UUID Generated"
