#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Switch
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "env" }
# @raycast.packageName switch

# Documentation:
# @raycast.description Switch between environments
# @raycast.author Raúl Cruz
# @raycast.authorURL https://github.com/rcruzper

switch "$@"
