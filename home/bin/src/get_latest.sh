get_latest_release() {
  # curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
  #   grep '"tag_name":' |                                            # Get tag line
  #   sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
  curl -Ls -o /dev/null -w %{url_effective} https://github.com/$1/releases/latest | 
    grep -o "tag/.*" | cut -d '/' -f 2
}

get_latest_release_num() {
    get_latest_release $1 |                                   
    grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?"                            # Pluck numeric value only
}
