#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v swiftlint >/dev/null 2>&1; then
  echo "swiftlint not found. Install with: brew install swiftlint"
  exit 1
fi

echo "Running SwiftLint..."
swiftlint lint --reporter emoji
