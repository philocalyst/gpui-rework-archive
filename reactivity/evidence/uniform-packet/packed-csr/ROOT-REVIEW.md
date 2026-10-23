# Packed retained-suffix cursor, preserved and unadopted

Source 5559828a4f6d093401cc374654f634b4d8fb9ddb is compared directly with
shipping 7a5e1619a27010ec63f6c27506a6d1fcd113f67c. Its forward retained
count determines the exact reverse painter suffix, removing the per-tile
cursor allocation and the final statistics traversal. This first packed form
adds shader range decoding; the later endpoint-spare-bit experiment attempts
to remove that decoding without restoring the deleted storage.

Default/fallback/offline tests and strict checks, Apple/Windows compilation,
the original 52 fixed readbacks, and 584 named readbacks pass. Complete work
counters match. A wrong reverse order fails the private oracle and changes
28 of 52 public SDR/HDR images; a count fault fails 21280 versus 10640, and
restoration passes. The max-count probe exercises 65,536 translucent draws.

The measured bill is explicit: one 24-byte Vec header and its four-byte-per-
tile capacity are removed; linked default/offline text falls 352 bytes.
Core grows 14 lines, default rodata 256 bytes/offline 640, and each fragment
SPIR-V artifact grows 132 bytes. The shader adds two masks, a shift and an
addition. Those costs are not omitted because CPU storage improves. The
observer-heavy functional process durations are not a timing campaign.

Root independently reopened all 3,879 payloads (123,575,954 bytes) and all 14
external ELF/compiler identities, checked lengths and hashes, and verified
the copied archive/manifest. The complete artifact includes all commands,
guards, failures, readbacks and assembly bills. ELFs stay external at the
manifest paths. This historical experiment is not adopted; no speed,
hardware-GPU, RSS or whole-application improvement is claimed here.
