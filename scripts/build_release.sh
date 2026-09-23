#!/usr/bin/env bash
# ==============================================================================
# Script: build_release.sh
# Purpose: Validate code health, run test suite, and build release App Bundle (AAB)
# Project: Beauty in Shadow - Dual Reign
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Discover flutter binary
if command -v flutter >/dev/null 2>&1; then
  FLUTTER_BIN="flutter"
elif [ -x "/opt/flutter/bin/flutter" ]; then
  FLUTTER_BIN="/opt/flutter/bin/flutter"
else
  echo "❌ Error: Flutter CLI binary not found in PATH or /opt/flutter/bin/flutter." >&2
  exit 1
fi

cd "${PROJECT_ROOT}"

echo "=============================================================="
echo " Beauty in Shadow: Dual Reign — Production Release Build Pipeline"
echo "=============================================================="
echo "Project Root: ${PROJECT_ROOT}"
echo "Flutter CLI:  $(${FLUTTER_BIN} --version | head -n 1)"
echo "Timestamp:    $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo "=============================================================="

# --------------------------------------------------------------
# Step 1: Static Code Analysis
# --------------------------------------------------------------
echo ""
echo "▶ [1/4] Running Static Analysis (flutter analyze)..."
if ${FLUTTER_BIN} analyze; then
  echo "✅ Static analysis passed: 0 errors, 0 warnings."
else
  echo "❌ Static analysis failed! Please fix issues before releasing." >&2
  exit 1
fi

# --------------------------------------------------------------
# Step 2: Automated Test Suite Execution
# --------------------------------------------------------------
echo ""
echo "▶ [2/4] Executing Complete Test Suite (flutter test)..."
if ${FLUTTER_BIN} test; then
  echo "✅ All tests passed successfully."
else
  echo "❌ Test suite failed! Release build aborted." >&2
  exit 1
fi

# --------------------------------------------------------------
# Step 3: Check Android Signing Setup
# --------------------------------------------------------------
echo ""
echo "▶ [3/4] Verifying Android Signing Configuration..."
KEY_PROPS="${PROJECT_ROOT}/android/key.properties"
if [ -f "${KEY_PROPS}" ]; then
  echo "✅ Production key.properties detected."
else
  echo "⚠️ Warning: android/key.properties not found."
  echo "   The build will automatically fallback to debug signing for testing."
  echo "   To sign with production key, run: ./scripts/generate_keystore.sh"
fi

# --------------------------------------------------------------
# Step 4: Build Google Play App Bundle (AAB)
# --------------------------------------------------------------
echo ""
echo "▶ [4/4] Building Release App Bundle (flutter build appbundle --release)..."

# Check if Android SDK is available
HAS_ANDROID_SDK=false
if [ -n "${ANDROID_HOME:-}" ] && [ -d "${ANDROID_HOME}" ]; then
  HAS_ANDROID_SDK=true
elif [ -n "${ANDROID_SDK_ROOT:-}" ] && [ -d "${ANDROID_SDK_ROOT}" ]; then
  HAS_ANDROID_SDK=true
fi

if [ "${HAS_ANDROID_SDK}" = "false" ]; then
  echo "⚠️ Notice: Android SDK is not locally configured in this environment."
  echo "   Gradle build cannot compile native binaries without Android SDK."
  echo "   Analysis, tests, and configuration validations have PASSED."
  echo "   When running on a machine with Android SDK installed (or CI/CD):"
  echo "     $ ${FLUTTER_BIN} build appbundle --release"
  echo "=============================================================="
  echo "🎉 Pre-flight release checks completed successfully!"
  exit 0
fi

if ${FLUTTER_BIN} build appbundle --release; then
  AAB_PATH="${PROJECT_ROOT}/build/app/outputs/bundle/release/app-release.aab"
  echo ""
  echo "=============================================================="
  echo "🎉 Production App Bundle Built Successfully!"
  echo "=============================================================="
  if [ -f "${AAB_PATH}" ]; then
    AAB_SIZE=$(du -h "${AAB_PATH}" | cut -f1)
    SHA256_HASH=$(sha256sum "${AAB_PATH}" | cut -d ' ' -f 1)
    echo "Artifact:    ${AAB_PATH}"
    echo "Size:        ${AAB_SIZE}"
    echo "SHA256:      ${SHA256_HASH}"
    echo ""
    echo "Ready for upload to Google Play Console (Internal/Production track)."
  else
    echo "Artifact located at default build directory."
  fi
  echo "=============================================================="
else
  echo "❌ Error: Failed to build release app bundle." >&2
  exit 1
fi
