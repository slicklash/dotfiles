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

function set_thumb() {
  if [ -z "$2" ]; then
    echo "Usage: $0 <time> <input>"
  else
    ffmpeg -ss $1 -i "$2" -frames:v 1 -q:v 5 out.png
    mv "$2" "$2.bak"
    ffmpeg -i "$2.bak" -i out.png -map 0 -map 1 -c copy -c:v:1 png -disposition:v:1 attached_pic "$2"
    rm out.png
  fi
}

_gitignireio_get_command_list() {
  curl -s https://www.gitignore.io/api/list | tr "," "\n"
}

_gitignireio () {
  compset -P '*,'
  compadd -S '' `_gitignireio_get_command_list`
}

compdef _gitignireio gi
