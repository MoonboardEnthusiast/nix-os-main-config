#!/usr/bin/env bash
if [[ -n "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

find  $SCRIPT_DIR -type f \( -name "*.nix" -o -name "*.lua" \) | while read -r file; do
  echo "Processing: $file"
  if [[ "$file" == *.nix ]]; then
     echo "Processing Nix file: $file"
     # Nix-specific logic here
     echo "  This is a Nix configuration file"
        
  elif [[ "$file" == *.lua ]]; then
     echo "Processing Lua file: $file"
     # Lua-specific logic here
     echo "  This is a Lua script file"
  fi 
done
# Interactive file copy script with diff and confirmation options

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color





