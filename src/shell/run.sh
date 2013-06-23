# ==============================================================================
# Run
# ==============================================================================

initCliPath
validateImgPath
validateImageOptim
validateImageAlpha
validateJpegMini

if [ "directory" == $RUN_MODE ]; then
  processDirectory
elif [ "stdin" == $RUN_MODE ]; then
  processFiles
fi
