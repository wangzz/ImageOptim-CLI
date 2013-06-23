# ==============================================================================
# Run
# ==============================================================================

initCliPath
validateImgPath
validateImageOptim
validateImageAlpha
validateJpegMini

if [ "directory" == $RUN_MODE ]; then
  handleDirectory
elif [ "stdin" == $RUN_MODE ]; then
  handleStdin
fi
