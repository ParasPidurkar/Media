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

# Generate HLS Stream
ffmpeg -i "$INPUT_VIDEO" -profile:v baseline -level 3.0 -s 640x360 -start_number 0 -hls_time 10 -hls_list_size 0 -f hls "$HLS_DIR/playlist.m3u8"

# Generate DASH Stream
ffmpeg -i "$INPUT_VIDEO" -map 0 -b:v:0 800k -s:v:0 640x360 -b:v:1 1200k -s:v:1 1280x720 -c:a aac -use_timeline 1 -use_template 1 -f dash "$DASH_DIR/manifest.mpd"

echo "HLS and DASH streams generated in '$OUTPUT_DIR'"
