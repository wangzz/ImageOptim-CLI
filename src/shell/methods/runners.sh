# (): Get a timestamp for the current time
function now {
  date +"%s"
}

# (): How long did ImageOptim.app take to process the images?
function getTimeSpent {
  let timeSpent=endTime-startTime-$isBusyIntervalLength
  echo $timeSpent
}

# ($1:dirPath): How many images are in the directory we're about to process?
function getImgCount {
  echo $(find -E "$1" -iregex $imageOptimFileTypes | wc -l)
}

# (): run applications against a directory of images
function processDirectory {
  startTime=$(now)
  imgCount=$(getImgCount "$imgPath")
  echo "Processing $imgCount images..."

  if [ "true" == $useImageAlpha ]; then
    runImageAlphaOnDirectory "$imgPath"
    waitForImageAlpha
  fi

  if [ "true" == $useJPEGmini ]; then
    runJPEGmini "$imgPath"
    waitForJPEGmini
  fi

  if [ "true" == $useImageOptim ]; then
    runImageOptimOnDirectory "$imgPath"
    waitForImageOptim
  fi

  endTime=$(now)
  success "Finished in $(getTimeSpent) seconds" | xargs
}

# (): run applications against a single image
function processFiles {

  local i=0
  local fileSizes=()

  # store piped input so we can iterate over it more than once
  while read LINE; do
    pipedFiles[$i]="${LINE}"
    i=$((i+1))
  done

  # ($1:array, $2:filter, $3:iterator)
  function forEachFileOfType {
    declare -a array=("${!1}")
    for file in "${array[@]}"; do
      if [ "" != "`echo "$file" | grep -E $2`" ]; then
        $3 "$file"
      fi
    done
  }

  # ($1:file, $2:logName)
  function addFileSizeToLog {
    size=$(sizeInBytes "$1")
    fileSizes+=("$1:$2:$size")
  }

  # ($1:file)
  function logFileSizeBeforeStarting {
    addFileSizeToLog $1 "Original"
  }

  # ($1:file)
  function logFileSizeAfterImageAlpha {
    addFileSizeToLog $1 "ImageAlpha"
  }

  # ($1:file)
  function logFileSizeAfterImageOptim {
    addFileSizeToLog $1 "ImageOptim"
  }

  # ($1:file)
  function logFileSizeAfterJpegMini {
    addFileSizeToLog $1 "JPEGmini"
  }

  echo "Processing $i images..."

  forEachFileOfType pipedFiles[@] '{{imageFileTypes}}' logFileSizeBeforeStarting

  # ImageAlpha
  if [ "true" == $useImageAlpha ]; then
    forEachFileOfType pipedFiles[@] '{{imageAlphaFileTypes}}' runImageAlphaOnImage
    waitForImageAlpha
    forEachFileOfType pipedFiles[@] '{{imageAlphaFileTypes}}' logFileSizeAfterImageAlpha
  fi

  # JPEGmini
  if [ "true" == $useJPEGmini ]; then
    forEachFileOfType pipedFiles[@] '{{jpegMiniFileTypes}}' runJPEGmini
    waitForJPEGmini
    forEachFileOfType pipedFiles[@] '{{jpegMiniFileTypes}}' logFileSizeAfterJpegMini
  fi

  # ImageOptim
  if [ "true" == $useImageOptim ]; then
    forEachFileOfType pipedFiles[@] '{{imageOptimFileTypes}}' runImageOptimOnImage
    waitForImageOptim
    forEachFileOfType pipedFiles[@] '{{imageOptimFileTypes}}' logFileSizeAfterImageOptim
  fi

  # Output
  # ----------------------------------------------------------------------------

  for entry in "${fileSizes[@]}"; do
    local name=$(echo "$entry" | cut -d':' -f 1)
    local appName=$(echo "$entry" | cut -d':' -f 2)
    local size=$(echo "$entry" | cut -d':' -f 3)
    echo "$name $(toKb $size)kb ($appName)"
  done | sort

}
