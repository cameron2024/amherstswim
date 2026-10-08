# Handoff: "Storm Over Colby" AI Video Intro (Claude Code)

## Read this first: who does what
- **Claude Code cannot generate the footage.** There is no video generation model inside it, and Cameron has no video-model API key.
- **Cameron generates the raw clips** in a consumer video app (Davinci.ai / Seedance 2.5 once credits refresh, or similar) using the prompts below, and drops the files into `clips/`.
- **Claude Code does everything after that:** set up tools, organize the clips, stitch with hard cuts, fade to black, color-match, add sound, export the final MP4.
- This is the **intro** to a larger video. Ask Cameron what follows it (and whether it needs title text or a logo) before deciding how fancy the assembly needs to be.

## Tool checklist (install/verify first; Cameron is on a Mac)
Check what is already installed before installing anything.

| Tool | Why | Notes |
|---|---|---|
| **Homebrew** | Installs the rest on macOS | Skip if already present |
| **Node.js (current LTS)** | Required by Remotion and HyperFrames | Verify the minimum version each tool needs |
| **ffmpeg** (`brew install ffmpeg`) | Core tool: cut, concat (hard cuts), fade to black, scale to 1080p, mix audio, export. Also needed by HyperFrames to assemble frames | Required |
| **HyperFrames** (HeyGen, open source, Apache 2.0) | Code-based video composition (HTML/CSS/GSAP) for titles, overlays, grade, and layering audio. Setup: `npx skills add heygen-com/hyperframes`, then `npx hyperframes init storm-over-colby`; commands include `preview` and `render` | Recommended if the intro needs text or overlays. Verify install steps in the README |
| **Remotion** (React-based) | Alternative to HyperFrames for the same job | **Install one or the other, not both.** Check Remotion's license terms if this is anything beyond personal/student use |
| **Epidemic Sound** | Royalty-free sound effects (distant thunder, wind, natatorium ambience) | **Optional and needs a paid subscription.** Has an MCP server; Claude Code connects with an API key (not one-click login) and the server is in beta. Docs: developers.epidemicsound.com/docs/mcp. If Cameron has no subscription, skip it and keep the audio the video app generates |

**Recommendation:** start with **ffmpeg only**. A hard-cut sequence with a final fade to black needs nothing else. Add HyperFrames (or Remotion) only if the intro needs titles, overlays, or a more controlled grade. Add Epidemic Sound only if the generated audio is weak.

## Folder layout
```
storm-over-colby/
  refs/        <- unzipped Colby.zip (reference photos)
  clips/       <- raw clips Cameron downloads from the video app (shot1.mp4 ... shot5.mp4, or full.mp4)
  audio/       <- optional SFX
  out/         <- final exports
  HANDOFF.md
```
Reference photos (in `Colby.zip`, folder `Colby/`): exterior_library_main.jpg, exterior_library_side_low.jpeg, exterior_library_side2.jpeg, exterior_library_above.jpg, exterior_east_quad.jpeg, exterior_south_quad.png (has people; ignore them), interior_pool_high.jpeg, interior_pool_high2.jpg. Ignore the `__MACOSX` folder and `.DS_Store`. These are for Cameron to upload as references in the video app and for you to check architecture accuracy in results. **Never use them as a first frame.**

## Workflow
1. Set up tools and folders; confirm with Cameron.
2. Cameron generates clips (see prompts below) and drops them in `clips/`.
3. Inspect each clip with `ffprobe` (length, resolution, fps, audio track). Report back.
4. **Test first:** do a rough stitch of whatever exists before polishing.
5. Assemble: hard cuts only, no transitions, final shot fades to black. Target ~16-18s total. Normalize resolution/fps across clips; export 1080p MP4 (upscale is fine if clips are 720p).
6. Match look across clips if they differ (desaturated cool grade, consistent light).
7. Audio: low and restrained. Faint wind/rustling, soft distant thunder under every shot, natatorium ambience in the pool shot. No music, no loud sounds. Use generated audio if it's good; otherwise layer SFX.
8. Export to `out/` and show Cameron a preview before any re-do.

## Creative direction (decided, don't relitigate)
- **Mood:** something insidious is arriving, not ordinary weather. Inspired by the unnatural dark clouds scene in *Harry Potter and the Half-Blood Prince*. **Never put the movie name in a generation prompt**; describe the look.
- **Camera:** every shot is a **squirrel's-eye view**: a few inches off the ground, tilted up.
- **Clouds:** real-time, slow, heavy, deliberate. **No time-lapse.** Low, dense, black-grey, smoky edges that coil as if alive.
- **People:** none outdoors. Only a few distant swimmers doing routine laps in the pool shot.
- **Cuts:** hard cuts only.

## Shot list (~16s)
| # | Time | Shot |
|---|------|------|
| 1 | 0-3s | **Quad.** In the grass, blades in foreground, red-brick dorms blurred behind, clouds creeping in over rooftops. |
| 2 | 3-6s | **Walkway.** Base of a tree trunk; shadow spreads across the path; leaves barely stir. |
| 3 | 6-10s | **Pool.** Camera at the water's edge on the deck, looking across the pool and up at the glass window wall; dark clouds visible through the glass and reflected on the water; swimmers faint in far lanes. **Do not copy the reference photos' high-in-the-stands angle.** |
| 4 | 10-13s | **Library tower (hero).** Extreme low angle straight up at the Miller Library clock tower and spire, clouds coiling around the spire. |
| 5 | 13-16s | **Finale.** Wide low angle, tower silhouetted, faint distant lightning flicker, then fade to black. |

**Architecture details:** red-brick Georgian Revival buildings with white trim, dormers, tall chimneys, pale green copper roofs. Library: white-columned portico with triangular pediment, wide stone steps up a grassy slope; tower has a square brick base, white clock stage, open white colonnaded belfry, slender white spire, weathervane. Natatorium (Harold Alfond Athletics and Recreation Center): white curved steel truss roof with diagonal bracing, tall glass window wall with horizontal louvers, white deck, 50-meter pool with blue and white lane lines.

## Prompt A: full 16s multi-shot (try this first)
Written for Seedance 2.5, 16:9, 16s, 720p is enough. Upload all 8 reference photos as references.

```
A 16-second cinematic multi-shot sequence of a quiet New England college campus (Colby College, Maine) as something sinister approaches. Every shot is filmed from a squirrel's point of view: camera a few inches above the ground, tilted upward, wide-angle lens. Use the reference images ONLY to match the exact architecture and materials. Do NOT copy their camera angles. No people in any outdoor shot; the only people are a few distant swimmers in the pool scene. Hard cuts between shots.

THE CLOUDS: Real-time motion, NOT time-lapse. Unnaturally dark, heavy, black-grey storm clouds creep slowly and deliberately across the sky, low and dense, with smoky, coiling edges that curl and drift as if alive and searching. They feel wrong, like something insidious is arriving rather than ordinary weather. As they advance, the daylight drains away and the world goes eerily still.

Architecture to match from the references: red-brick Georgian Revival buildings with white trim, white-framed windows, dormers, tall chimneys and pale green copper roofs. The library has a white-columned portico with a triangular pediment, wide stone steps rising up a grassy slope, and a tall clock tower: square red-brick base, white clock stage with clock faces, an open white colonnaded belfry, and a slender white spire topped with a weathervane. The natatorium has a white curved steel truss roof with diagonal cross-bracing, a long wall of tall glass windows with horizontal louvers, a white pool deck, and a 50-meter pool with blue water, blue-and-white lane lines and starting blocks.

Shot 1 (0-3s): Ground level in the grass of a campus quad, blades of grass sharp in the foreground, red-brick dormitories softly blurred behind. Above the rooftops, the dark clouds slowly creep into view, their edges coiling like smoke. The sunlight begins to fade. Very slow push forward through the grass.

Shot 2 (3-6s): At the base of a large tree trunk beside a campus walkway, looking toward the red-brick buildings. The leaves barely stir. A shadow slowly spreads across the path and buildings as the heavy clouds advance overhead. Static camera.

Shot 3 (6-10s): Inside the natatorium. The pool reference photos are taken from high in the stands; ignore that angle. Camera sits on the pool deck right at the water's edge, the water surface filling the bottom of the frame, looking across the pool and up at the towering wall of glass windows. In the far lanes, a few swimmers do steady, routine freestyle laps, small and slightly out of focus in the background, completely unaware of the sky. Through the glass, the dark clouds slowly roll in and press low over the trees, their smoky edges curling. The light inside gradually dims and the dark sky reflects on the gently rippling water as the swimmers' wakes reach the near edge. Very slow push forward.

Shot 4 (10-13s): Hero shot. From the grass at the foot of the library steps, extreme low angle looking straight up at the clock tower and spire. The black clouds slowly gather and coil around the top of the spire, swallowing the sky, the white tower glowing pale against the creeping darkness. Very slow upward tilt.

Shot 5 (13-16s): Wide low angle from the lawn, the library and tower silhouetted beneath the dense, heavy clouds. Deep within the clouds, a faint, distant flicker of lightning glows briefly, then fade to black.

Audio: low and restrained throughout. Outdoors: very faint wind, very faint rustling of grass and leaves, an unsettling near-silence. Distant thunder rumbles low and soft but is clearly present, rolling in under every shot. Inside the pool: the echoing ambience of a natatorium, the rhythmic splash of swimmers' strokes and kicks, an occasional flip-turn splash, water lapping against the gutter, all slightly muffled and distant, with the faint thunder rumbling through the glass. No loud sounds, no music.

Style: photorealistic, cinematic, foreboding, desaturated cool color grade, 35mm film look, consistent lighting across all shots, no text.
```

## Prompt B: per-shot fallback (if A is too costly or the shots don't hold together)
Generate each shot as its own ~3-4s clip. Paste the **shared preamble** at the top of every prompt, then one shot. Reference photos per shot: shots 1-2 quad photos, shot 3 pool photos, shots 4-5 library photos. Short clips are cheaper and easier to redo one at a time. **Shot 4 (the hero) is the best one to test first.**

**Shared preamble:**
```
Cinematic, photorealistic, a quiet New England college campus (Colby College, Maine) as something sinister approaches. Filmed from a squirrel's point of view: camera a few inches above the ground, tilted upward, wide-angle lens. Use the reference images ONLY to match architecture and materials, NOT their camera angles. No people. Unnaturally dark, heavy, black-grey storm clouds creep slowly and deliberately across the sky in real time (NOT time-lapse), low and dense, with smoky coiling edges that drift as if alive. Something insidious is arriving, not ordinary weather. Foreboding, desaturated cool color grade, 35mm film look, no text. Audio: very faint wind and rustling, near-silence, soft distant thunder, no music.
```
**Shot 1:** Ground level in the grass of a campus quad, blades of grass sharp in the foreground, red-brick Georgian Revival dormitories with white trim softly blurred behind. Above the rooftops the dark clouds slowly creep into view. Sunlight begins to fade. Very slow push forward through the grass.

**Shot 2:** At the base of a large tree trunk beside a campus walkway, looking toward red-brick buildings. Leaves barely stir. A shadow slowly spreads across the path and buildings as heavy clouds advance overhead. Static camera.

**Shot 3:** Inside a natatorium. Camera on the pool deck right at the water's edge, water surface filling the bottom of the frame, looking across the pool and up at a towering wall of glass windows with horizontal louvers, white curved steel truss roof, 50-meter pool with blue-and-white lane lines. A few distant swimmers do routine freestyle laps in the far lanes, small and out of focus, unaware of the sky. Through the glass the dark clouds roll in low over the trees; the dark sky reflects on the rippling water; the light dims. Echoing natatorium ambience, muffled splashes, faint thunder through the glass. Very slow push forward.

**Shot 4 (hero):** From the grass at the foot of the library steps, extreme low angle looking straight up at a red-brick clock tower with white clock stage, open white colonnaded belfry, and slender white spire with weathervane. Black clouds slowly gather and coil around the top of the spire, swallowing the sky; the white tower glows pale against the darkness. Very slow upward tilt.

**Shot 5:** Wide low angle from the lawn, the library (white-columned portico, triangular pediment) and tower silhouetted beneath dense heavy clouds. Deep within the clouds a faint distant flicker of lightning glows briefly, then fade to black.

## Notes
- Seedance 2.5 appears natively 720p; Davinci's 1080p is likely upscaled. Generate at 720p, upscale in ffmpeg.
- Davinci doesn't show credit cost per generation. Cameron should note credits used by the first test so the rest can be budgeted.
- Copyright: the reference photos are Colby's or their photographers'. Fine for personal use; flag it if the video is posted publicly.
- Cameron prefers brief explanations. Ask clarifying questions before long or multi-step work.
