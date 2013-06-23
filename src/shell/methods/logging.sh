# ==============================================================================
# Logging
# ==============================================================================

# (): Display usage information
function usage {
{{usage}}
}

# (): Display usage examples
function examples {
{{examples}}
}

# ($1:message): Display a red error message and quit
function error {
  printf "\e[31m✘ $1"
  echo "\033[0m"
  exit 1
}

# ($1:message): Display a message in green with a tick by it
function success {
  printf "\e[32m✔ ${1}"
  echo "\033[0m"
}

# ($1:file, $2:logName)
function addFileSizeToLog {
  local size=$(sizeInBytes "$1")
  FILE_SIZES+=("$1:$2:$size")
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
