#!/bin/bash
# 2013-09-10: Derek Gottlieb

SCRIPTPATH=$(dirname $(readlink -f $0))

if [ -z $1 ]; then
 echo "Usage: $0 SHOW SEASON FIRST_EP START_TRACK END_TRACK"
 exit 1
else
 SHOW=$1
fi

if [ -z $2 ]; then
 echo "Usage: $0 SHOW SEASON FIRST_EP START_TRACK END_TRACK"
 exit 1
else
 SEASON=$2
fi

if [ -z $3 ]; then
 echo "Usage: $0 SHOW SEASON FIRST_EP START_TRACK END_TRACK"
 exit 1
else
 FIRST_EP=$3
fi

if [ -z $4 ]; then
 echo "Usage: $0 SHOW SEASON FIRST_EP START_TRACK END_TRACK"
 exit 1
else
 START_TRACK=$4
fi

if [ -z $5 ]; then
 echo "Usage: $0 SHOW SEASON FIRST_EP START_TRACK END_TRACK"
 exit 1
else
 END_TRACK=$5
fi

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
