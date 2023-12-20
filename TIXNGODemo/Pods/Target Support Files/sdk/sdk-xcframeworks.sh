#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR


# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")


variant_for_slice()
{
  case "$1" in
  "app_settings.xcframework/ios-arm64")
    echo ""
    ;;
  "app_settings.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "App.xcframework/ios-arm64")
    echo ""
    ;;
  "App.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "beacon.xcframework/ios-arm64")
    echo ""
    ;;
  "beacon.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "connectivity_plus.xcframework/ios-arm64")
    echo ""
    ;;
  "connectivity_plus.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "contacts_service.xcframework/ios-arm64")
    echo ""
    ;;
  "contacts_service.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "core.xcframework/ios-arm64")
    echo ""
    ;;
  "core.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "DTTJailbreakDetection.xcframework/ios-arm64")
    echo ""
    ;;
  "DTTJailbreakDetection.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "Flutter.xcframework/ios-arm64")
    echo ""
    ;;
  "Flutter.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "FlutterPluginRegistrant.xcframework/ios-arm64")
    echo ""
    ;;
  "FlutterPluginRegistrant.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "FMDB.xcframework/ios-arm64")
    echo ""
    ;;
  "FMDB.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "in_app_review.xcframework/ios-arm64")
    echo ""
    ;;
  "in_app_review.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "KeychainSwift.xcframework/ios-arm64")
    echo ""
    ;;
  "KeychainSwift.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "native_font.xcframework/ios-arm64")
    echo ""
    ;;
  "native_font.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "path_provider_foundation.xcframework/ios-arm64")
    echo ""
    ;;
  "path_provider_foundation.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "permission_handler_apple.xcframework/ios-arm64")
    echo ""
    ;;
  "permission_handler_apple.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "phone_number.xcframework/ios-arm64")
    echo ""
    ;;
  "phone_number.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "PhoneNumberKit.xcframework/ios-arm64")
    echo ""
    ;;
  "PhoneNumberKit.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "Reachability.xcframework/ios-arm64")
    echo ""
    ;;
  "Reachability.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "safe_device.xcframework/ios-arm64")
    echo ""
    ;;
  "safe_device.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "screenshot_prevention.xcframework/ios-arm64")
    echo ""
    ;;
  "screenshot_prevention.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "share_plus.xcframework/ios-arm64")
    echo ""
    ;;
  "share_plus.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "shared_preferences_foundation.xcframework/ios-arm64")
    echo ""
    ;;
  "shared_preferences_foundation.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "sqflite.xcframework/ios-arm64")
    echo ""
    ;;
  "sqflite.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "system_uptime.xcframework/ios-arm64")
    echo ""
    ;;
  "system_uptime.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "url_launcher_ios.xcframework/ios-arm64")
    echo ""
    ;;
  "url_launcher_ios.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "wallet_suppression.xcframework/ios-arm64")
    echo ""
    ;;
  "wallet_suppression.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "webview_flutter_wkwebview.xcframework/ios-arm64")
    echo ""
    ;;
  "webview_flutter_wkwebview.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  esac
}

archs_for_slice()
{
  case "$1" in
  "app_settings.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "app_settings.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "App.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "App.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "beacon.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "beacon.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "connectivity_plus.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "connectivity_plus.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "contacts_service.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "contacts_service.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "core.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "core.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "DTTJailbreakDetection.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "DTTJailbreakDetection.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "Flutter.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "Flutter.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "FlutterPluginRegistrant.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "FlutterPluginRegistrant.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "FMDB.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "FMDB.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "in_app_review.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "in_app_review.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "KeychainSwift.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "KeychainSwift.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "native_font.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "native_font.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "path_provider_foundation.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "path_provider_foundation.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "permission_handler_apple.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "permission_handler_apple.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "phone_number.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "phone_number.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "PhoneNumberKit.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "PhoneNumberKit.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "Reachability.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "Reachability.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "safe_device.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "safe_device.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "screenshot_prevention.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "screenshot_prevention.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "share_plus.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "share_plus.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "shared_preferences_foundation.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "shared_preferences_foundation.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "sqflite.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "sqflite.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "system_uptime.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "system_uptime.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "url_launcher_ios.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "url_launcher_ios.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "wallet_suppression.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "wallet_suppression.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "webview_flutter_wkwebview.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "webview_flutter_wkwebview.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  esac
}

copy_dir()
{
  local source="$1"
  local destination="$2"

  # Use filter instead of exclude so missing patterns don't throw errors.
  echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" \"${source}*\" \"${destination}\""
  rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" "${source}"/* "${destination}"
}

SELECT_SLICE_RETVAL=""

select_slice() {
  local xcframework_name="$1"
  xcframework_name="${xcframework_name##*/}"
  local paths=("${@:2}")
  # Locate the correct slice of the .xcframework for the current architectures
  local target_path=""

  # Split archs on space so we can find a slice that has all the needed archs
  local target_archs=$(echo $ARCHS | tr " " "\n")

  local target_variant=""
  if [[ "$PLATFORM_NAME" == *"simulator" ]]; then
    target_variant="simulator"
  fi
  if [[ ! -z ${EFFECTIVE_PLATFORM_NAME+x} && "$EFFECTIVE_PLATFORM_NAME" == *"maccatalyst" ]]; then
    target_variant="maccatalyst"
  fi
  for i in ${!paths[@]}; do
    local matched_all_archs="1"
    local slice_archs="$(archs_for_slice "${xcframework_name}/${paths[$i]}")"
    local slice_variant="$(variant_for_slice "${xcframework_name}/${paths[$i]}")"
    for target_arch in $target_archs; do
      if ! [[ "${slice_variant}" == "$target_variant" ]]; then
        matched_all_archs="0"
        break
      fi

      if ! echo "${slice_archs}" | tr " " "\n" | grep -F -q -x "$target_arch"; then
        matched_all_archs="0"
        break
      fi
    done

    if [[ "$matched_all_archs" == "1" ]]; then
      # Found a matching slice
      echo "Selected xcframework slice ${paths[$i]}"
      SELECT_SLICE_RETVAL=${paths[$i]}
      break
    fi
  done
}

install_xcframework() {
  local basepath="$1"
  local name="$2"
  local package_type="$3"
  local paths=("${@:4}")

  # Locate the correct slice of the .xcframework for the current architectures
  select_slice "${basepath}" "${paths[@]}"
  local target_path="$SELECT_SLICE_RETVAL"
  if [[ -z "$target_path" ]]; then
    echo "warning: [CP] $(basename ${basepath}): Unable to find matching slice in '${paths[@]}' for the current build architectures ($ARCHS) and platform (${EFFECTIVE_PLATFORM_NAME-${PLATFORM_NAME}})."
    return
  fi
  local source="$basepath/$target_path"

  local destination="${PODS_XCFRAMEWORKS_BUILD_DIR}/${name}"

  if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
  fi

  copy_dir "$source/" "$destination"
  echo "Copied $source to $destination"
}

install_xcframework "${PODS_ROOT}/sdk/app_settings.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/App.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/beacon.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/connectivity_plus.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/contacts_service.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/core.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/DTTJailbreakDetection.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/Flutter.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/FlutterPluginRegistrant.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/FMDB.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/in_app_review.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/KeychainSwift.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/native_font.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/path_provider_foundation.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/permission_handler_apple.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/phone_number.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/PhoneNumberKit.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/Reachability.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/safe_device.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/screenshot_prevention.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/share_plus.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/shared_preferences_foundation.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/sqflite.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/system_uptime.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/url_launcher_ios.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/wallet_suppression.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/sdk/webview_flutter_wkwebview.xcframework" "sdk" "framework" "ios-arm64" "ios-arm64_x86_64-simulator"

