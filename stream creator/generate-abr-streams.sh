#!/bin/bash

# Check if a file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <video-file>"
    exit 1
fi

INPUT_VIDEO=$1
OUTPUT_DIR=$(basename "${INPUT_VIDEO%.*}")_output
HLS_DIR=$OUTPUT_DIR/hls
DASH_DIR=$OUTPUT_DIR/dash

# Create output directories
mkdir -p "$HLS_DIR"
mkdir -p "$DASH_DIR"

# Get video resolution
RESOLUTION=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$INPUT_VIDEO")
WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2)

# Define bitrate and resolution levels
# Example: 360p, 480p, 720p, 1080p
LEVELS=("640x360" "854x480" "1280x720" "1920x1080")
BITRATES=("800k" "1400k" "2800k" "5000k")

# Generate HLS Stream
for i in "${!LEVELS[@]}"; do
    if [ "${LEVELS[$i]}" = "$WIDTH"x"$HEIGHT" ] || [ "${LEVELS[$i]}" \< "$WIDTH"x"$HEIGHT" ]; then
        ffmpeg -i "$INPUT_VIDEO" -c:v libx264 -c:a aac -b:v ${BITRATES[$i]} -vf "scale=${LEVELS[$i]}" -hls_time 10 -hls_list_size 0 -f hls "$HLS_DIR/${LEVELS[$i]}.m3u8"
    fi
done

# Generate DASH Stream
for i in "${!LEVELS[@]}"; do
    if [ "${LEVELS[$i]}" = "$WIDTH"x"$HEIGHT" ] || [ "${LEVELS[$i]}" \< "$WIDTH"x"$HEIGHT" ]; then
        ffmpeg -i "$INPUT_VIDEO" -map 0 -c:v libx264 -c:a aac -b:v ${BITRATES[$i]} -vf "scale=${LEVELS[$i]}" -use_timeline 1 -use_template 1 -f dash "$DASH_DIR/${LEVELS[$i]}.mpd"
    fi
done

echo "HLS and DASH ABR streams generated in '$OUTPUT_DIR'"
