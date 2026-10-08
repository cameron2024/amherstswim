#!/usr/bin/env bash
# Stitch the storm intro: hard cuts, 1080p, final fade to black.
#
# Input:  clips/full.mp4 (Prompt A) or clips/shot1.mp4 ... shot5.mp4 (Prompt B).
#         Missing shots are skipped, so a rough stitch works with any subset.
# Output: out/storm_over_colby.mp4
#
# Options (env vars):
#   GRADE=1    apply a desaturated cool grade to every clip (to match mismatched clips)
#   FADE=1.0   fade-to-black length in seconds
#   FPS=24     output frame rate
set -euo pipefail
cd "$(dirname "$0")"
shopt -s nullglob

FADE=${FADE:-1.0}
FPS=${FPS:-24}
GRADE=${GRADE:-0}

if [ -f clips/full.mp4 ]; then
  inputs=(clips/full.mp4)
else
  inputs=()
  for n in 1 2 3 4 5; do
    for ext in mp4 mov; do
      [ -f "clips/shot$n.$ext" ] && inputs+=("clips/shot$n.$ext") && break
    done
  done
fi
if [ ${#inputs[@]} -eq 0 ]; then
  echo "No clips found. Put full.mp4 or shot1.mp4 ... shot5.mp4 in clips/." >&2
  exit 1
fi

vf="scale=1920:1080:force_original_aspect_ratio=decrease:flags=lanczos"
vf+=",pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=$FPS"
if [ "$GRADE" = 1 ]; then
  vf+=",eq=saturation=0.8:contrast=1.04,colorbalance=rs=-0.03:bs=0.04:rm=-0.02:bm=0.03"
fi
vf+=",format=yuv420p"

rm -rf build && mkdir -p build out
: > build/list.txt

# Normalize every clip to identical streams so the concat is a clean hard cut.
i=0
for f in "${inputs[@]}"; do
  if [ -n "$(ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$f")" ]; then
    audio=(-map 0:a:0)
  else
    # No audio track: pad with silence so every part has the same streams.
    audio=(-f lavfi -i anullsrc=r=48000:cl=stereo -map 1:a -shortest)
  fi
  ffmpeg -v error -y -i "$f" "${audio[@]}" -map 0:v:0 \
    -vf "$vf" -c:v libx264 -crf 12 -preset medium \
    -af "aresample=48000,aformat=channel_layouts=stereo" -c:a pcm_s16le \
    "build/part$i.mov"
  echo "file 'part$i.mov'" >> build/list.txt
  echo "normalized $(basename "$f")"
  i=$((i + 1))
done

total=$(for p in build/part*.mov; do
  ffprobe -v error -show_entries format=duration -of csv=p=0 "$p"
done | awk '{ s += $1 } END { printf "%.3f", s }')
start=$(awk -v t="$total" -v f="$FADE" 'BEGIN { printf "%.3f", t - f }')

ffmpeg -v error -y -f concat -safe 0 -i build/list.txt \
  -vf "fade=t=out:st=$start:d=$FADE" -af "afade=t=out:st=$start:d=$FADE" \
  -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p \
  -c:a aac -b:a 192k -movflags +faststart \
  out/storm_over_colby.mp4

printf "wrote out/storm_over_colby.mp4 (%.2fs)\n" "$total"
