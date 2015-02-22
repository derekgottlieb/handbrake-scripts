#!/bin/bash
# 2013-09-10: Derek Gottlieb

function print_usage {
 echo "Usage: $0 [-s /dev/sr0] [-d $HOME/Videos] [-e 480p] [-t TRACK] -n NAME"
 echo " Valid encode options: 480p, 720p, 1080p"
}

SOURCE="/dev/sr0"
DIR="$HOME/Videos"
NAME=""
TRACK=""
ENCODE="480p"

while getopts "s:d:n:t:e:" Option
do
  case $Option in
    s)
        SOURCE=$OPTARG
        ;;
    d)
        DIR=$OPTARG
        ;;
    n)
        NAME=$OPTARG
        ;;
    t)
        TRACK=$OPTARG
        ;;
    e)
        ENCODE=$OPTARG
        ;;
   esac
done
shift $(($OPTIND - 1))

# Track is only needed if we're ripping from a DVD
TRACK_OPT=""
IS_SOURCE_DEV=$(echo $SOURCE | grep -c "^/dev")
if [ "$IS_SOURCE_DEV" -gt 0 ]; then
 if [ -z "$TRACK" ]; then
  print_usage
  exit
 else
  TRACK_OPT="-t $TRACK"
 fi
fi

# If source is a ripped mkv, we can use it's filename if not specified
IS_SOURCE_MKV=$(echo $SOURCE | grep -c "mkv$")
IS_SOURCE_MPG=$(echo $SOURCE | grep -c "mpg$")
if [ "$IS_SOURCE_MKV" -gt 0 ] && [ -z "$NAME" ]; then
 NAME=$(basename $SOURCE | sed -e 's/\.mkv//')
elif [ "$IS_SOURCE_MPG" -gt 0 ] && [ -z "$NAME" ]; then
 NAME=$(basename $SOURCE | sed -e 's/\.mpg//')
else
 if [ -z "$NAME" ]; then
  print_usage
  exit
 fi
fi

case $ENCODE in
 "480p")
  ENCODE_OPTS="-e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,auto -R Auto,Auto -D 0.0,0.0 -f mp4 --detelecine --decomb --loose-anamorphic --modulus 8 -m -x b-adapt=2:rc-lookahead=50"
  ;;
 "720p")
  # AppleTV 2 defaults
  #ENCODE_OPTS='-Z "AppleTV 2"'

  # AppleTV 2, but with modulus 8 instead of 2
  ENCODE_OPTS="-e x264  -q 20.0 -r 30 --pfr  -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,auto -R Auto,Auto -D 0.0,0.0 --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3 -f mp4 -4 -X 1280 -Y 720 --loose-anamorphic --modulus 8 -m --x264-preset medium --h264-profile high --h264-level 3.1"
  ;;
 "1080p")
  # AppleTV 3 defaults
  #ENCODE_OPTS='-Z "AppleTV 3"'

  # AppleTV 3, but with modulus 8 instead of 2
  ENCODE_OPTS="-e x264  -q 20.0 -r 30 --pfr  -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,auto -R Auto,Auto -D 0.0,0.0 --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3 -f mp4 -4 -X 1920 -Y 1080 --decomb=fast --loose-anamorphic --modulus 8 -m --x264-preset medium --h264-profile high --h264-level 4.0"
  ;;
 *)
  echo "ERROR: Invalid encode option: $ENCODE. Valid options are 480p, 720p, 1080p."
  exit
  ;;
esac

#HandBrakeCLI -i /dev/dvd -o ${DIR}/$1.m4v -t $2 -e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,auto -R Auto,Auto -D 0.0,0.0 -f mp4 --detelecine --decomb --loose-anamorphic -m -x b-adapt=2:rc-lookahead=50

HandBrakeCLI -i "${SOURCE}" -o "${DIR}/${NAME}_${ENCODE}.m4v" ${TRACK_OPT} ${ENCODE_OPTS}

