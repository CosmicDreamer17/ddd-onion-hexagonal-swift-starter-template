#!/bin/bash
set -e

echo "Running architectural verification..."

# 1. CoreDomain must not import UI frameworks
echo "Checking CoreDomain for invalid imports..."
INVALID_DOMAIN=$(grep -rnw 'CoreDomain/Sources' -e 'import SwiftUI' -e 'import UIKit' -e 'import AppKit' --include=\*.swift || true)
if [ ! -z "$INVALID_DOMAIN" ]; then
    echo "❌ ERROR: CoreDomain must not import UI frameworks! Found:"
    echo "$INVALID_DOMAIN"
    exit 1
fi
echo "✅ CoreDomain imports valid."

# 2. CoreData (infrastructure) must not import UI frameworks
echo "Checking CoreData layer for UI imports..."
INVALID_UI_IN_COREDATA=$(grep -rnw 'CoreData/Sources' -e 'import SwiftUI' -e 'import UIKit' -e 'import AppKit' --include=\*.swift || true)
if [ ! -z "$INVALID_UI_IN_COREDATA" ]; then
    echo "❌ ERROR: CoreData (infrastructure) must not import UI frameworks! Found:"
    echo "$INVALID_UI_IN_COREDATA"
    exit 1
fi
echo "✅ CoreData layer imports valid."

# 3. CoreUI (presentation) must not import persistence frameworks directly
echo "Checking CoreUI layer for persistence imports..."
INVALID_PERSISTENCE_IN_COREUI=$(grep -rnw 'CoreUI/Sources' -e 'import SwiftData' -e 'import GRDB' -e 'import RealmSwift' --include=\*.swift || true)
if [ ! -z "$INVALID_PERSISTENCE_IN_COREUI" ]; then
    echo "❌ ERROR: CoreUI must not import persistence frameworks directly! Found:"
    echo "$INVALID_PERSISTENCE_IN_COREUI"
    exit 1
fi
echo "✅ CoreUI layer imports valid."

# 4. Run SwiftLint if installed
if command -v swiftlint >/dev/null 2>&1; then
    echo "Running SwiftLint..."
    swiftlint lint --strict
    echo "✅ SwiftLint passed."
else
    echo "⚠️  SwiftLint not installed. Skipping linting."
fi

# 5. Run all SPM package tests
echo "Running CoreDomain tests..."
(cd CoreDomain && swift test)

echo "Running CoreData tests..."
(cd CoreData && swift test)

echo "Running CoreUI tests..."
(cd CoreUI && swift test)

echo "✅ All automated checks passed!"
