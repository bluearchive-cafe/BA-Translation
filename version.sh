set -euo pipefail

REGION="${1:-JP}"
INFO_JSON_FILE="${2:-info.json}"

last_seg() { basename "$1"; }

parse_with_awk() {
    local region="$1"
    local key="$2"
    local file="$3"
    
    awk -v region="\"$region\"" -v key="\"$key\"" '
    $0 ~ region { in_region=1 }
    in_region && $0 ~ key {
        match($0, key "[[:space:]]*:[[:space:]]*\"[^\"]*")
        if (RSTART) {
            value=substr($0, RSTART, RLENGTH)
            gsub(key "[[:space:]]*:[[:space:]]*\"", "", value)
            print value
            exit
        }
    }
    in_region && /^    }/ { exit }
    ' "$file"
}

ADDRESSABLE_CATALOG_URL=$(parse_with_awk "$REGION" "AddressableCatalogUrl" "$INFO_JSON_FILE")
APK_VERSION_CODE=$(parse_with_awk "$REGION" "APKVersionCode" "$INFO_JSON_FILE")
APK_VERSION_NAME=$(parse_with_awk "$REGION" "APKVersionName" "$INFO_JSON_FILE")
TABLE_VERSION=$(parse_with_awk "$REGION" "TableVersion" "$INFO_JSON_FILE")

case "$REGION" in
    "CN")
        BUILD_VERSION="${APK_VERSION_NAME}-${APK_VERSION_CODE}(${TABLE_VERSION})"
        ;;
    "GL")
        BUILD_VERSION="${APK_VERSION_NAME}-${APK_VERSION_CODE}($(last_seg "$ADDRESSABLE_CATALOG_URL"))"
        ;;
    *)
        BUILD_VERSION="${APK_VERSION_NAME}-${APK_VERSION_CODE}($(last_seg "$ADDRESSABLE_CATALOG_URL"))"
        ;;
esac

FLATDATA_VERSION="${APK_VERSION_NAME}-${APK_VERSION_CODE}"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    {
        echo "BA_VERSION_NAME=$BUILD_VERSION"
        echo "FLATDATA_VERSION_NAME=$FLATDATA_VERSION"
    } >> "$GITHUB_OUTPUT"
else
    echo "BA_VERSION_NAME: $BUILD_VERSION"
    echo "FLATDATA_VERSION_NAME: $FLATDATA_VERSION"
fi
