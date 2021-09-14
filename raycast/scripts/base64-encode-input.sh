#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Base64 Encode
# @raycast.mode silent
# @raycast.packageName Developer Utilities
#
# Optional parameters:
# @raycast.icon 🔐
# @raycast.needsConfirmation false
# @raycast.argument1 { "type": "text", "placeholder": "text", "optional": false }
#
# Documentation:
# @raycast.description Encode any text data by using base64
# @raycast.author Raúl Cruz
# @raycast.authorURL https://github.com/rcruzper

echo -n $1 | base64 | tr -d '\n' | pbcopy
echo "Copied to clipboard"
