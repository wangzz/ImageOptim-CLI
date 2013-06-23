# ==============================================================================
# Misc Functions
# ==============================================================================

# ($1:array, $2:filter, $3:iterator)
function forEachFileOfType {
  declare -a array=("${!1}")
  for file in "${array[@]}"; do
    if [ "" != "`echo "$file" | grep -E $2`" ]; then
      $3 "$file"
    fi
  done
}

# (): Get a timestamp for the current time
function now {
  date +"%s"
}

# (): How long did ImageOptim.app take to process the images?
function getTimeSpent {
  let timeSpent=endTime-startTime-$WAIT_INTERVAL
  echo $timeSpent
}

# ($1:dirPath): How many images are in the directory we're about to process?
function getImgCount {
  echo $(find -E "$1" -iregex $OPTIM_TYPES | wc -l)
}
