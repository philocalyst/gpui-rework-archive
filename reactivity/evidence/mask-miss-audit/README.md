# Whole-pixel mask miss selection audit

Production b817779c; diagnostic70b75c8c changes only optional CPU logging.
All8 corrected processes finish normally; all1082 packets select literal mask
tiles and all2587037 planned lowered references lie within selected tiles.
Exact initial0/190 images,17 workload tests, shader/ELF and source guards pass.
First-packet counts (each repeated across all4 modes):

- initial0: 262087 whole-pixel misses / 296960 lowered pixel references.
- initial190: 600100 whole-pixel misses / 683264 lowered pixel references.

These are planned complete-packet references, not repair-cropped GPU work,
texture loads, cache-hit counts or a performance result. Only submission1 is
enumerated; later packets report zero support counts.

The initial attempt failed window activation after one idle process because
the private X11 display had no window manager. Its SIGTERM exit, output, image,
unchanged source guards and complete frozen inputs are retained. Restored owned
openbox; separately froze and ran all8 diagnostic processes with unchanged
shader/workload/tests/thresholds. Original failure remains rejected. A static
script field-index correction made before observations is also preserved.

This audit admits the separate uninstrumented fixed native screen only.
