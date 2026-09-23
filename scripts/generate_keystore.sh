#!/usr/bin/env bash
# ==============================================================================
# Script: generate_keystore.sh
# Purpose: Generate production upload keystore and android/key.properties
# Project: Beauty in Shadow - Dual Reign
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

ANDROID_DIR="${PROJECT_ROOT}/android"
KEYSTORE_FILE="${ANDROID_DIR}/upload-keystore.jks"
KEY_PROPS_FILE="${ANDROID_DIR}/key.properties"

# Default or environment-provided values
KEY_ALIAS="${KEY_ALIAS:-upload}"
KEYSTORE_PASS="${KEYSTORE_PASS:-BeautyInShadowRelease2026}"
KEY_PASS="${KEY_PASS:-BeautyInShadowRelease2026}"
DNAME="${DNAME:-CN=BeautyInShadow, OU=Mobile, O=GHD, L=Paris, ST=IDF, C=FR}"

echo "=============================================================="
echo " Beauty in Shadow - Keystore & Signing Generator"
echo "=============================================================="

if [ -f "${KEYSTORE_FILE}" ]; then
  echo "⚠️ Keystore already exists at: ${KEYSTORE_FILE}"
  read -r -p "Overwrite existing keystore? [y/N]: " CONFIRM
  if [[ ! "${CONFIRM}" =~ ^[yY]$ ]]; then
    echo "Aborted. Existing keystore preserved."
    exit 0
  fi
  rm -f "${KEYSTORE_FILE}"
fi

echo "Generating 2048-bit RSA upload keystore..."
keytool -genkeypair \
  -v \
  -keystore "${KEYSTORE_FILE}" \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias "${KEY_ALIAS}" \
  -storepass "${KEYSTORE_PASS}" \
  -keypass "${KEY_PASS}" \
  -dname "${DNAME}"

echo "Writing configuration to ${KEY_PROPS_FILE}..."
cat <<EOF > "${KEY_PROPS_FILE}"
storePassword=${KEYSTORE_PASS}
keyPassword=${KEY_PASS}
keyAlias=${KEY_ALIAS}
storeFile=upload-keystore.jks
EOF

# Set strict file permissions (read/write only by owner)
chmod 600 "${KEYSTORE_FILE}" "${KEY_PROPS_FILE}"

echo ""
echo "✅ Keystore generated successfully!"
echo "   Keystore:  ${KEYSTORE_FILE}"
echo "   Config:    ${KEY_PROPS_FILE}"
echo "   Key Alias: ${KEY_ALIAS}"
echo ""
echo "🔒 Security Note: Ensure neither *.jks nor key.properties are ever committed."
echo "   Both entries are protected in .gitignore."
echo "=============================================================="
