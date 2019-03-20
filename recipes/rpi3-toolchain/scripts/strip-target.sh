set -ex

TARGET_LIBRARIES=$(find $2 $3)

for lib in $TARGET_LIBRARIES ; do
    $1-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_pubtypes -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc $lib || true
done
