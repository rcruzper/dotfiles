#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Base64 Decode
# @raycast.mode silent
# @raycast.packageName Developer Utilities
#
# Optional parameters:
# @raycast.icon 🔓
# @raycast.needsConfirmation false
# @raycast.argument1 { "type": "text", "placeholder": "text", "optional": false }
#
# Documentation:
# @raycast.description Decode the base64 string
# @raycast.author Raúl Cruz
# @raycast.authorURL https://github.com/rcruzper

echo $1 | base64 --decode | tr -d '\n' | pbcopy
echo "Copied to clipboard"
