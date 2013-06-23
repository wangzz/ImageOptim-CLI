# ==============================================================================
# App Watchers
# ==============================================================================

# ($1:appName): Get the number of processes in use by an Application
function countProcesses {
  printf $(ps -aef | grep  "[${1:0:1}]${1:1}.app" | wc -l)
}

# ($1:appName): Sleep until app is done optimising images
function waitForApp {
  # wait for App to spawn a few processes
  sleep 2
  # wait until those processes have completed
  while [[ $(countProcesses $1) > "1" ]]; do
    sleep $WAIT_INTERVAL
  done
}

# ($1:appName):
function waitForPornelApp {
  waitForApp $1
  if [ "true" == $QUIT_AFTER ]; then
    osascript -e "tell application \"$1\" to quit"
  fi
}

# ():
function waitForImageOptim {
  if [ "true" == $USE_OPTIM ]; then
    waitForPornelApp $OPTIM_NAME
  fi
}

# ():
function waitForImageAlpha {
  if [ "true" == $USE_ALPHA ]; then
    waitForPornelApp $ALPHA_NAME
  fi
}

# ():
function waitForJPEGmini {
  if [ "true" == $USE_JPEGMINI ]; then
    sleep 1
    `osascript "$CLI_PATH/imageOptimAppleScriptLib" wait_for $JPEGMINI_NAME` > /dev/null 2>&1
    if [ "true" == $QUIT_AFTER ]; then
      osascript -e "tell application \"$JPEGMINI_NAME\" to quit"
    fi
  fi
}
