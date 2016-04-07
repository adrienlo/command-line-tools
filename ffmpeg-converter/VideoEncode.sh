#!/bin/bash
DefaultBitRate=1500k

usage() {
    echo "Usage: -f <Folder> -b <Bitrate> -w <Width>"; exit 1;
}

while getopts ":b:w:f:" opt; do
    case $opt in
        b)
            TargetBitrate=$OPTARG
            ;;
        f)
            Folder=$OPTARG
            ;;
        w)
            TargetWidth=$OPTARG
            ;;
        *)
            usage
            ;;
    esac
done

# Check if a folder was passed to -f
if [[ ! $Folder ]]; then
    echo "-f is required. specify a folder to encode." >&2
    exit 2
fi

# if Bitrate is passed, check to see if unit is passed
if [[ $TargetBitrate ]]; then
    if [[ $TargetBitrate != *"k"* ]]; then
        TargetBitrate=${TargetBitrate}k
    fi
else
# set default Bitrate if none is passed
    TargetBitrate=$DefaultBitRate
fi

# Output folder for encoded videos
Output="${Folder}/output/"

if [ ! -d $Output ]; then
    mkdir -p $Output
fi

for f in $(find "$Folder" -name '*.mp4' -maxdepth 1)
do
    File=${f##*/}
    Filename=${File%.*}
    EncodedFileName=${Filename}_${TargetBitrate}

    # webm conversion
    ffmpeg -i "$f" -c:v libvpx -crf 10 -minrate 1M -maxrate 1M -b:v 1M -c:a libvorbis -y "$Output$Filename.webm"

    # ogg conversion
    ffmpeg -i "$f" -codec:v theora -q:v 8 -y "$Output$Filename.ogg"

    # 2-pass H264 conversion
    if [[ $TargetWidth ]]; then
        ffmpeg -i "$f" -codec:v libx264 -profile:v high -preset veryslow -tune film -b:v $TargetBitrate -pass 1 -codec:a libvo_aacenc -b:a 128k -f mp4 -y -vf scale=${TargetWidth}:-1 "temp_file.mp4"
        ffmpeg -i "$f" -codec:v libx264 -profile:v high -preset veryslow -tune film -b:v $TargetBitrate -pass 2 -codec:a libvo_aacenc -b:a 128k -f mp4 -y -vf scale=${TargetWidth}:-1 "$Output${EncodedFileName}_${TargetWidth}.mp4"
    else
        ffmpeg -i "$f" -codec:v libx264 -profile:v high -preset veryslow -tune film -b:v $TargetBitrate -pass 1 -codec:a libvo_aacenc -b:a 128k -f mp4 -y "temp_file.mp4"
        ffmpeg -i "$f" -codec:v libx264 -profile:v high -preset veryslow -tune film -b:v $TargetBitrate -pass 2 -codec:a libvo_aacenc -b:a 128k -f mp4 -y "$Output$EncodedFileName.mp4"
    fi

    rm temp_file.mp4
    rm ffmpeg2pass-0.log
    rm ffmpeg2pass-0.log.mbtree
done

exit;