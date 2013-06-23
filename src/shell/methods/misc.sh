# ($1:array, $2:filter, $3:iterator)
function forEachFileOfType {
  declare -a array=("${!1}")
  for file in "${array[@]}"; do
    if [ "" != "`echo "$file" | grep -E $2`" ]; then
      $3 "$file"
    fi
  done
}
