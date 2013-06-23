# ==============================================================================
# File Sizes
# ==============================================================================

# ($1:path)
function sizeInBytes {
  stat -f %z "$1"
}

# ($1:bytes) -> kilobytes
# Convert a value in bytes to kilobytes to 3 decimal places, so 1b is
# 0.001kb
# EXAMPLE: (1500) -> 1.500
function toKb {
  echo $(bc <<< "scale=3; $1/1000")
}
