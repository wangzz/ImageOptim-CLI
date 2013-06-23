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

  function end {
    echo "$1" | cut -c1-60
  }

  format="%-60s %12s %12s %10s %12s %10s\n"
  printf "$format" "Image" "Before" "ImageAlpha" "JPEGmini" "ImageOptim" "Savings"

  for file in "${files[@]}"; do
    local var=${file//[^a-zA-Z0-9]/x}

    originalSizeVar="original_${var}"
    imagealphaSizeVar="imagealpha_${var}"
    jpegminiSizeVar="jpegmini_${var}"
    imageoptimSizeVar="imageoptim_${var}"

    originalSize="${!originalSizeVar}"
    imagealphaSize=${!imagealphaSizeVar}
    jpegminiSize=${!jpegminiSizeVar}
    imageoptimSize="${!imageoptimSizeVar}"
    savings=$(echo "$originalSize - $imageoptimSize" | bc)

    savings="$(toKb $savings)kb"
    originalSize="$(toKb $originalSize)kb"
    imageoptimSize="$(toKb $imageoptimSize)kb"

    if [ ! -e $imagealphaSize ]; then
      imagealphaSize="$(toKb $imagealphaSize)kb"
    else
      imagealphaSize="-"
    fi

    if [ ! -e $jpegminiSize ]; then
      jpegminiSize="$(toKb $jpegminiSize)kb"
    else
      jpegminiSize="-"
    fi

    printf "$format" $(end "$file") "$originalSize" "$imagealphaSize" "$jpegminiSize" "$imageoptimSize" "$savings"

  done

  endTime=$(now)
  success "Finished in $(getTimeSpent) seconds" | xargs
}
