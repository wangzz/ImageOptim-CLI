# ==============================================================================
# Runners
# ==============================================================================

# (): run applications against a directory of images
function processDirectory {
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

# (): run applications against a single image
function processFiles {

  startTime=$(now)
  local i=0

  # store piped input so we can iterate over it more than once
  while read LINE; do
    local pipedFiles[$i]="${LINE}"
    i=$((i+1))
  done

  echo "Processing $i images..."

  forEachFileOfType pipedFiles[@] '{{imageFileTypes}}' logFileSizeBeforeStarting

  # ImageAlpha
  if [ "true" == $USE_ALPHA ]; then
    forEachFileOfType pipedFiles[@] '{{imageAlphaFileTypes}}' runImageAlphaOnImage
    waitForImageAlpha
    forEachFileOfType pipedFiles[@] '{{imageAlphaFileTypes}}' logFileSizeAfterImageAlpha
  fi

  # JPEGmini
  if [ "true" == $USE_JPEGMINI ]; then
    forEachFileOfType pipedFiles[@] '{{jpegMiniFileTypes}}' runJPEGmini
    waitForJPEGmini
    forEachFileOfType pipedFiles[@] '{{jpegMiniFileTypes}}' logFileSizeAfterJpegMini
  fi

  # ImageOptim
  if [ "true" == $USE_OPTIM ]; then
    forEachFileOfType pipedFiles[@] '{{imageOptimFileTypes}}' runImageOptimOnImage
    waitForImageOptim
    forEachFileOfType pipedFiles[@] '{{imageOptimFileTypes}}' logFileSizeAfterImageOptim
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
