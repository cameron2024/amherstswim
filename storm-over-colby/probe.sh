#!/usr/bin/env bash
# Report length, resolution, fps and audio for every clip in clips/.
set -euo pipefail
cd "$(dirname "$0")"
shopt -s nullglob

clips=(clips/*.mp4 clips/*.mov)
if [ ${#clips[@]} -eq 0 ]; then
  echo "No clips in clips/ yet."
  exit 0
fi

printf "%-20s %8s %10s %8s %s\n" FILE SECONDS SIZE FPS AUDIO
for f in "${clips[@]}"; do
  dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f")
  vid=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate -of csv=p=0 "$f")
  IFS=, read -r w h rate <<<"$vid"
  fps=$(awk -F/ '{ printf "%.2f", ($2 ? $1/$2 : $1) }' <<<"$rate")
  aud=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,sample_rate,channels -of csv=p=0 "$f")
  printf "%-20s %8.2f %10s %8s %s\n" "$(basename "$f")" "$dur" "${w}x${h}" "$fps" "${aud:-none}"
done
