# ==============================================================================
# Handle CLI Options
# ==============================================================================

while [ "$1" != "" ]; do
  case $1 in
    -d | --directory )
      shift;
      RUN_MODE="directory"
      DIR_PATH=$1
      ;;
    -a | --image-alpha )
      USE_ALPHA="true"
      ;;
    -j | --jpeg-mini )
      USE_JPEGMINI="true"
      ;;
    -q | --quit )
      QUIT_AFTER="true"
      ;;
    -h | --help )
      usage;
      exit 0
      ;;
    -e | --examples )
      examples;
      exit 0
      ;;
    -v | --version )
      echo $VERSION;
      exit 0
      ;;
    * )
    usage
    exit 1
  esac
  shift
done
