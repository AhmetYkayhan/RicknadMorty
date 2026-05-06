#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v swiftformat >/dev/null 2>&1; then
  echo "swiftformat not found. Install with: brew install swiftformat"
  exit 1
fi

echo "Formatting Swift sources..."
swiftformat RicknadMorty Packages
echo "Format applied."
