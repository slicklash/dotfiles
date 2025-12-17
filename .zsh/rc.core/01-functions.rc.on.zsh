function scp117 {
  [[ "$#" != 1  ]] && return 1
  scp -P 8022 $1 192.168.1.117:~/tmp/
}

function scpf117 {
  [[ "$#" != 2  ]] && return 1
  scp -P 8022 192.168.1.117:$1 $2
}

function scp109 {
  [[ "$#" != 1  ]] && return 1
  scp -P 8022 $1 192.168.1.109:~/tmp/
}

function scpf109 {
  [[ "$#" != 2  ]] && return 1
  scp -P 8022 192.168.1.109:$1 $2
}

function cbfile {
  [[ "$#" != 1  ]] && return 1
  local file_to_copy=$1
  cat $file_to_copy | xsel --clipboard --input
}

function cbdir {
  pwd | tr -d "\r\n" | xsel --clipboard --input
}

function gi() { curl https://www.gitignore.io/api/$@ ; }

function xsb() {
  [[ "$#" != 1  ]] && return 1
  x-seen-by $1 | sed 's/,/\n/g'
}

function rc() {
  [[ "$#" != 2  ]] && return 1
  for x in {$1..$2}; echo $x && xfce4-screenshooter -r -s "/home/slicklash/code/pwa2/public/img/q_sign_$x.png"
}

function v2gif() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <input> <output> <scale> <skip> <length>"
  else
    ffmpeg -y -ss $4 -t $5 -i $1 -filter_complex "fps=10,scale=$3:-1:flags=lanczos[x];[x]split[x1][x2]; [x1]palettegen[p];[x2][p]paletteuse" $2
  fi
}

function v_set_thumb() {
  if [ -z "$2" ]; then
    echo "Usage: $0 <time> <input>"
  else
    ffmpeg -ss $1 -i "$2" -frames:v 1 -q:v 5 out.png
    if [[ -f "$2.bak" ]]; then
      rm "$2"
    else
      mv "$2" "$2.bak"
    fi
    ffmpeg -i "$2.bak" -i out.png -map 0 -map 1 -c copy -c:v:1 png -disposition:v:1 attached_pic "$2"
    rm out.png
  fi
}

function v_trim_start() {
  if [ -z "$3" ]; then
    echo "Usage: $0 <time_sec> <input> <out>"
  else
    ffmpeg -ss "$1" -i "$2" -map 0 -c copy "$3"
  fi
}

function v_trim_end() {
  if [ -z "$3" ]; then
    echo "Usage: $0 <time> <input> <out>"
  else
    ffmpeg -to "$1" -i "$2" -map 0 -c copy "$3"
  fi
}

function v_replace_audio() {
  if [ -z "$3" ]; then
    echo "Usage: $0 <input> <audio> <output> <offset>"
  else
    local input="$1"
    local audio="$2"
    local output="${3:-output.mp4}"
    local offset="${4}"
    local common_args=(-i "$input")

    if [ -n "$offset" ]; then
        common_args=("${common_args[@]}" -itsoffset "$offset" -i "$audio")
    else
        common_args=("${common_args[@]}" -i "$audio")
    fi
    common_args=("${common_args[@]}" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0)

    ffmpeg "${common_args[@]}" "$output"
  fi
}

function v_compress() {
  if [ -z "$2" ]; then
    echo "Usage: $0 <input> <out> <q> <fps> <duration>"
  else
    local input="$1"
    local output="$2"
    local quality="${3:-20}"
    local fps="${4:-25}"
    local duration="$5"

    local common_args=(-i "$input" -c:v libx265 -preset veryslow -crf "$quality" \
        -x265-params "fps=$fps:vbv-bufsize=12800:vbv-maxrate=6000:aq-mode=3" \
        -c:a copy)

    [[ -n "$duration" ]] && common_args=(-t "$duration" "${common_args[@]}")

    ffmpeg "${common_args[@]}" "$output"
  fi
}

function v_encode() {
  if [ -z "$2" ]; then
    echo "Usage: $0 <input> <out> <q>"
  else
    local input="$1"
    local output="$2"
    local quality="${3:-20}"
    ffmpeg -init_hw_device vaapi=va:/dev/dri/renderD128 -filter_hw_device va \
           -i "$input" -vf 'format=nv12,hwupload' \
           -c:v hevc_vaapi -rc_mode CQP -qp "$quality" -profile:v main \
           -c:a aac -b:a 256k -movflags +faststart "$output"
  fi
}

function v_info() {
  local path="${1:-.}"

  if [[ -f "$path" ]]; then
    codec=$(/usr/bin/ffprobe -v error -select_streams v:0 -show_entries stream=codec_name \
            -of default=noprint_wrappers=1:nokey=1 "$path" 2>/dev/null)
    size=$(/usr/bin/ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$path" 2>/dev/null)
    printf "%-50s %s %-10s\n" "$path" "${codec:-unknown}" "$size"
  elif [[ -d "$path" ]]; then
    /usr/bin/find "$path" -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.flv" -o -iname "*.webm" \) | /usr/bin/sort | while read -r file; do
      codec=$(/usr/bin/ffprobe -v error -select_streams v:0 -show_entries stream=codec_name \
              -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)
      size=$(/usr/bin/ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$path" 2>/dev/null)
      printf "%-50s %s %-10s\n" "$file" "${codec:-unknown}" "$size"
    done
  else
    echo "Error: '$path' is not a valid file or directory." >&2
    return 1
  fi
}

function v_fix_avi() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <input> <out>"
  else
    local out=${2:-output.mp4}
    local base_name="${1:t:r}"
    local unpacked="/tmp/unpacked_${base_name}.avi"
    ffmpeg -i "$1" -c:v copy -bsf:v mpeg4_unpack_bframes -c:a copy "$unpacked"
    ffmpeg -i "$unpacked" -ar 44100 -acodec aac -b:a 128k -vcodec copy "$out"
    rm "$unpacked"
  fi
}

function v_convert_avis() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <input-dir> <out-dir> <quality>"
  else
    local input_dir="$1"
    local output_dir="$2"
    local quality="${3:-23}"
    local total_files=$(find "$input_dir" -type f -name "*.avi" | wc -l)

    if [[ $total_files -eq 0 ]]; then
      echo "No AVI files found in '$input_dir'."
      return 1
    fi

    local counter=1

    mkdir -p "$output_dir"

    for avi_file in "$input_dir"/*.avi; do
      [[ -e "$avi_file" ]] || continue

      local base_name="${avi_file:t:r}"
      local tmp_file="/tmp/${base_name}.avi"
      local output_file="$output_dir/${base_name}.mp4"

      echo "Converting: ($counter/$total_files) $avi_file → $output_file"

      v_fix_avi $avi_file $tmp_file
      read -r width height <<< $(v_info "$tmp_file" | python -c "import sys;w,h=sys.stdin.read().strip().rsplit(' ',1)[-1].split(',');print(f'{w} {h}')")
      # ffmpeg -i "$tmp_file" -c:v libx265 -preset veryslow -crf $quality -c:a copy "$output_file"
      video2x -i $tmp_file -o $output_file -w $width -h $height -p libplacebo --libplacebo-shader anime4k-v4.1-gan -c libx265 -e crf=$quality -e preset=slow -e tune=animation
      rm "$tmp_file"

      ((counter++))
    done

    echo "[+] Done"
  fi
}

function img2b64() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <dir> [output]"
    return 0
  fi

  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    echo "Error: invalid directory"
    return 1
  fi

  local output_file="${2:-output.b64.json}"

  local tmp_json=$(mktemp)
  echo "{" > "$tmp_json"

  local first=1

  setopt EXTENDED_GLOB

  # Pattern: "<digits><space><anything>.png"
  for file in $dir/*; do
    [[ -e "$file" ]] || continue

    local filename="${file##*/}"

    # Validate pattern: digits + space + name + .png
    if [[ ! "$filename" =~ ^([0-9]+)\ (.+)\.png$ ]]; then
      continue
    fi

    echo "Processing: $file"

    local avif_file="${file%.png}.avif"

    # PNG → AVIF
    avifenc "$file" --qalpha 50 -q 50 -y 420 "$avif_file" >/dev/null 2>&1

    # Base64 encode AVIF
    local DATA_URL="$(base64 -w 0 "$avif_file")"

    # JSON key: remove dir prefix, remove .png, strip digits + space
    local base="${file##*/}"     # file name only
    local key="${base%.png}"
    key="${key##[0-9]## }"

    # Add comma except for first entry
    if (( first )); then
      first=0
    else
      echo "," >> "$tmp_json"
    fi

    printf '  "%s": "%s"' \
      "$key" \
      "$DATA_URL" >> "$tmp_json"
  done

  echo "\n}" >> "$tmp_json"

  mv "$tmp_json" "$output_file"
}

_gitignireio_get_command_list() {
  curl -s https://www.gitignore.io/api/list | tr "," "\n"
}

_gitignireio () {
  compset -P '*,'
  compadd -S '' `_gitignireio_get_command_list`
}

compdef _gitignireio gi
