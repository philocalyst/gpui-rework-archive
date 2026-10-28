# Whole-pixel mask miss: native selection audit

Diagnostic prerequisite to preregistration 662707d7; production b817779c.
Only optional CPU packet logging changes. Shader and workload byte unchanged.
Use the corrected mask classifier (atlas dimensions nonzero) and decode tile
flags before traversing. Retain all 17 mask-tiles audit fields. Append
miss_enumerated (0/1), lowered_pixel_references and whole_pixel_misses. Enumerate
only submission 1: for each lowered mask reference and tile pixel, evaluate the
same first/last sample support predicate using uploaded quarter-grid coordinates.
Require each process first packet has 0 < misses < lowered pixel references;
all later packets have no enumeration or support counts. These are planned
full-packet counts, not damage-cropped GPU loads or hardware cache hits.

Fresh opt3/fatLTO/CGU1 native profile, 17 workload tests. Independent GPU admission
must verify before observation. Shader bytes must match actual executed ELF.
Eight 3-second processes: initial0 then190, each idle/scroll/stream/both, normal
ingress, trace, pinned font, 960x720, X11:94 and llvmpipe4. Both idle images exact
against uninstrumented native oracle. All lowered references must occur inside
selected literal tiles. Freeze scripts before observation; retain failures;
source guards and minimum8GiB enforced. No performance/adoption claim.

## Environment correction before replacement cohort

Initial diagnostic stopped after one idle process: private display :94 had no window manager and xdotool windowactivate failed, process reaped via SIGTERM. This is an execution/environment failure, not a numerical result. Restore owned openbox and run all8 diagnostic processes in a separately frozen cohort; retain original sources, images, logs and guards. No shader, workload, threshold, timing protocol or fixture change. No performance observations have begun.
