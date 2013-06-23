# ==============================================================================
# Handle Directory
# ==============================================================================

# ()
function handleDirectory {
  startTime=$(now)
  imgCount=$(getImgCount "$DIR_PATH")
  echo "Processing $imgCount images..."

  files=( $(find -E "$DIR_PATH" -regex '{{imageFileTypes}}') )

  forEachFileOfType files[@] '{{imageFileTypes}}' logFileSizeBeforeStarting

  if [ "true" == $USE_ALPHA ]; then
    runImageAlphaOnDirectory "$DIR_PATH"
    waitForImageAlpha
    forEachFileOfType files[@] '{{imageAlphaFileTypes}}' logFileSizeAfterImageAlpha
  fi

  if [ "true" == $USE_JPEGMINI ]; then
    runJPEGmini "$DIR_PATH"
    waitForJPEGmini
    forEachFileOfType files[@] '{{jpegMiniFileTypes}}' logFileSizeAfterJpegMini
  fi

  if [ "true" == $USE_OPTIM ]; then
    runImageOptimOnDirectory "$DIR_PATH"
    waitForImageOptim
    forEachFileOfType files[@] '{{imageOptimFileTypes}}' logFileSizeAfterImageOptim
  fi

  for entry in "${FILE_SIZES[@]}"; do
    local name=$(echo "$entry" | cut -d':' -f 1)
    local appName=$(echo "$entry" | cut -d':' -f 2)
    local size=$(echo "$entry" | cut -d':' -f 3)
    echo "$name $(toKb $size)kb ($appName)"
  done | sort

  endTime=$(now)
  success "Finished in $(getTimeSpent) seconds" | xargs
}
