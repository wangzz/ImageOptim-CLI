# ==============================================================================
# App Launchers
# ==============================================================================

# ($1:appFileName, $2:imageFilePath):
function addImageToQueue {
  open -g -a $1 "$2"
}

# ($1:fileTypes, $2:appFileName, $3:dirPath): Queue direcory of images
function addDirectoryToQueue {
  find -E "$3" -regex $1 -print0 | while IFS= read -r -d $'\0' file; do
    addImageToQueue $2 "$file"
  done
}

# ($1:fileTypes, $2:appFileName, $3:dirPath):
function runPornelAppOnDirectory {
  addDirectoryToQueue $1 $2 "$3"
}

# ($1:dirPath):
function runImageOptimOnDirectory {
  runPornelAppOnDirectory $OPTIM_TYPES $OPTIM_FILE "$1"
}

# ($1:dirPath):
function runImageAlphaOnDirectory {
  runPornelAppOnDirectory $ALPHA_TYPES $ALPHA_FILE "$1"
}

# ($1:appFileName, $2:image):
function runPornelAppOnImage {
  addImageToQueue $1 "$2"
}

# ($1:image):
function runImageOptimOnImage {
  echo "{{imageOptimAppName}}: $1"
  runPornelAppOnImage $OPTIM_FILE "$1"
}

# ($1:image):
function runImageAlphaOnImage {
  echo "{{imageAlphaAppName}}: $1"
  runPornelAppOnImage $ALPHA_FILE "$1"
}

# ($1:path):
function runJPEGmini {
  echo "{{jpegMiniAppName}}: $1"
  `osascript "$CLI_PATH/imageOptimAppleScriptLib" run_jpegmini "$1" $JPEGMINI_NAME` > /dev/null 2>&1
}
