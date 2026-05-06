#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

PACKAGES=(
  "Packages/Core/AppCore"
  "Packages/Core/AppLogger"
  "Packages/Core/AppStorage"
  "Packages/Core/AppNetwork"
  "Packages/Core/DesignSystem"
  "Packages/FeatureInterfaces/AuthFeatureInterface"
  "Packages/FeatureInterfaces/HomeFeatureInterface"
  "Packages/FeatureInterfaces/ProfileFeatureInterface"
  "Packages/FeatureInterfaces/SettingsFeatureInterface"
  "Packages/Features/AuthFeature"
  "Packages/Features/HomeFeature"
  "Packages/Features/SettingsFeature"
  "Packages/Features/ProfileFeature"
)

failed=0
passed=0

for pkg in "${PACKAGES[@]}"; do
  echo ""
  echo "Testing $pkg"
  echo "------------------------------------------------"
  if (cd "$pkg" && swift test --quiet 2>&1); then
    echo "PASS: $pkg"
    passed=$((passed + 1))
  else
    echo "FAIL: $pkg"
    failed=$((failed + 1))
  fi
done

echo ""
echo "================================================"
echo "Results: $passed passed, $failed failed ($(( passed + failed )) total)"
if [[ $failed -gt 0 ]]; then
  echo "FAILED: $failed package(s) failed."
  exit 1
fi
echo "All packages green."
