#!/bin/bash
# 2013-09-10: Derek Gottlieb

SCRIPTPATH=$(dirname $(readlink -f $0))

if [[ $# -ne 5 ]]; then
 echo "Usage: $0 SHOW SEASON FIRST_EP START_TRACK END_TRACK"
 exit 1
fi

SHOW=$1
SEASON=$2
FIRST_EP=$3
START_TRACK=$4
END_TRACK=$5

# if available get the title and get the number of titles
#TITLE=$(echo "$LSDVDOUTPUT" | grep -i Disc | sed 's/Disc Title: //g')
#NOMTITLES=$(echo "$LSDVDOUTPUT" | grep -i Length | wc -l)
#echo $NOMTITLES

DIR="$HOME/Videos/${SHOW}/Season_${SEASON}"
mkdir -p $DIR

EP=$FIRST_EP
if [ $SEASON -lt 10 ]; then SEASON="0${SEASON}" ; fi


# iterate over each title
for (( c=$START_TRACK; c <= $END_TRACK; c++ )) do
 PREFIX=''
 if [ $EP -lt  10 ]; then PREFIX="0" ; fi

 FILE="${SHOW}_s${SEASON}e${PREFIX}${EP}"

 if [ -e ${DIR}/${FILE} ]; then
  echo "ERROR: Found existing ${DIR}/${FILE}. Aborting!"
  exit 1
 fi

 ${SCRIPTPATH}/hb-rip-and-encode.sh -n ${FILE} -d ${DIR} -e 480p -t $c

 EP=$((EP+1))
done

if [[ -x ~/bin/notify.sh ]]; then
  ~/bin/notify.sh "Rip complete for $SHOW disk starting with s$SEASON e$FIRST_EP"
fi
