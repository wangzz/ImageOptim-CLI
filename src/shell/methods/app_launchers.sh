# ==============================================================================
# App Launchers
# ==============================================================================

# ($1:appFileName, $2:imageFilePath):
function addImageToQueue {
  open -g -a $1 "$2"
}

# ($1:fileTypes, $2:appFileName, $3:dirPath): Queue direcory of images
function addDirectoryToQueue {
  find -E "$3" -regex $1 -print0 | while IFS= read -r -d $'\0' imgPath; do
    addImageToQueue $2 "$imgPath"
  done
}

# ($1:appName, $2:fileTypes, $3:appFileName, $4:dirPath):
function runPornelAppOnDirectory {
  addDirectoryToQueue $2 $3 "$4"
}

# ($1:dirPath):
function runImageOptimOnDirectory {
  runPornelAppOnDirectory $imageOptimAppName $imageOptimFileTypes $imageOptimAppFileName "$1"
}

# ($1:dirPath):
function runImageAlphaOnDirectory {
  runPornelAppOnDirectory $imageAlphaAppName $imageAlphaFileTypes $imageAlphaAppFileName "$1"
}

# ($1:appName, $2:fileTypes, $3:appFileName, $4:image):
function runPornelAppOnImage {
  addImageToQueue $3 "$4"
}

# ($1:image):
function runImageOptimOnImage {
  echo "{{imageOptimAppName}}: $1"
  runPornelAppOnImage $imageOptimAppName $imageOptimFileTypes $imageOptimAppFileName "$1"
}

# ($1:image):
function runImageAlphaOnImage {
  echo "{{imageAlphaAppName}}: $1"
  runPornelAppOnImage $imageAlphaAppName $imageAlphaFileTypes $imageAlphaAppFileName "$1"
}

# ($1:path):
function runJPEGmini {
  echo "{{jpegMiniAppName}}: $1"
  `osascript "$cliPath/imageOptimAppleScriptLib" run_jpegmini "$1" $jpegMiniAppName` > /dev/null 2>&1
}
