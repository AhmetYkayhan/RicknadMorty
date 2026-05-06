#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

# Yasak import kurallari:
# Format: PAKET_YOLU|YASAK_IMPORT_REGEX|ACIKLAMA
RULES=(
  "Packages/Core/AppCore|^import (AppLogger|AppStorage|AppNetwork|DesignSystem|.*Feature.*)|AppCore should not depend on other packages"
  "Packages/Core/AppLogger|^import (AppCore|AppStorage|AppNetwork|DesignSystem|.*Feature.*)|AppLogger should be standalone"
  "Packages/Core/AppStorage|^import (AppNetwork|DesignSystem|.*Feature.*)|AppStorage may only depend on AppCore"
  "Packages/Core/AppNetwork|^import (DesignSystem|.*Feature.*)|AppNetwork may only depend on AppCore + AppLogger"
  "Packages/Core/DesignSystem|^import (AppLogger|AppStorage|AppNetwork|.*Feature.*)|DesignSystem may only depend on AppCore"
  "Packages/FeatureInterfaces|^import (.*Feature\b(?!Interface))|FeatureInterfaces must not import concrete Feature packages"
  "Packages/Features/AuthFeature|^import (HomeFeature|ProfileFeature|SettingsFeature)|AuthFeature must not import sibling features"
  "Packages/Features/HomeFeature|^import (AuthFeature|ProfileFeature|SettingsFeature)|HomeFeature must not import sibling features"
  "Packages/Features/ProfileFeature|^import (AuthFeature|SettingsFeature)|ProfileFeature may import HomeFeature only"
  "Packages/Features/SettingsFeature|^import (AuthFeature|ProfileFeature)|SettingsFeature may import HomeFeature only"
  "RicknadMorty/AppShell|^import FirebaseAuth|App target must not import FirebaseAuth (encapsulated in AuthFeature)"
)

failed=0

echo "Architecture import-graph check"
echo "================================================"

for rule in "${RULES[@]}"; do
  IFS='|' read -r path regex desc <<< "$rule"

  if [[ ! -d "$path" ]]; then
    continue
  fi

  matches=$(grep -RnE "$regex" --include="*.swift" --exclude-dir=".build" "$path" 2>/dev/null || true)

  if [[ -n "$matches" ]]; then
    echo "FAIL: $desc"
    echo "   In: $path"
    echo "$matches" | sed 's/^/      /'
    echo ""
    failed=$((failed + 1))
  else
    echo "PASS: $desc"
  fi
done

echo "================================================"
if [[ $failed -gt 0 ]]; then
  echo "FAILED: $failed rule(s) violated."
  exit 1
fi
echo "All architecture rules passed."
