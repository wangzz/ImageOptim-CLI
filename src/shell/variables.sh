# ==============================================================================
# GLOBALS
# ==============================================================================

# current version of ImageOptim-CLI from package.json
VERSION="{{version}}"

# "stdin"     == find img/*.gif | imageOptim
# "directory" == imageOptim --directory img/
RUN_MODE="stdin"

# value of --directory when RUN_MODE is "directory"
DIR_PATH="{{imgPath}}"

# absolute path to this script
CLI_PATH="{{cliPath}}"

# not configurable
USE_OPTIM="{{useImageOptim}}"

# enabled by --image-alpha
USE_ALPHA="{{useImageAlpha}}"

# enabled by --jpeg-mini
USE_JPEGMINI="{{useJPEGmini}}"

# enabled by --quit
QUIT_AFTER="{{quitOnComplete}}"

# how often to poll Pornel's apps to check if finished
WAIT_INTERVAL={{isBusyIntervalLength}}

# file types supported by each app
ALPHA_TYPES="{{imageAlphaFileTypes}}"
OPTIM_TYPES="{{imageOptimFileTypes}}"
JPEGMINI_TYPES="{{jpegMiniFileTypes}}"

# bundle ids for each app
ALPHA_ID="{{imageAlphaAppBundleId}}"
OPTIM_ID="{{imageOptimAppBundleId}}"
JPEGMINI_ID="{{jpegMiniAppBundleId}}"
JPEGMINI_ID_RETAIL="{{jpegMiniAppRetailBundleId}}"

# app process names
ALPHA_NAME="{{imageAlphaAppName}}"
OPTIM_NAME="{{imageOptimAppName}}"
JPEGMINI_NAME="{{jpegMiniAppName}}"

# app .app file names
ALPHA_FILE="{{imageAlphaAppFileName}}"
OPTIM_FILE="{{imageOptimAppFileName}}"
JPEGMINI_FILE="{{jpegMiniAppFileName}}"

# log file sizes before and after each app
FILE_SIZES=()
