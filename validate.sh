#!/bin/bash
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
nix-instantiate --parse "$SCRIPT_DIR/configuration.nix"
