# Endpoint spare-bit cursor, independently checked and unadopted

Root reviewed source 6bf679e2b2fe175d87eddeea7e4f7362f042bf17, its complete
production/test diff, retained-suffix argument and upload/replay/error paths.
Root reopened all 7,331 payloads (124,655,534 bytes), all 14 external binary
identities, and verified the copied archive and manifest hashes.

The temporary remaining count uses spare bits in the existing two endpoint
words. Filling consumes that count until the words become the exact shipping
start/end pair. The separate cursor vector and final statistics traversal are
removed. The shader source, generated WGSL and all eight SPIR-V artifacts are
byte-identical to shipping; no GPU decoder is added.

The 52 fixed and 584 named readbacks match shipping, with complete work
counters. All 574 eligible current CPU tile/reference packets are byte-exact;
ten explicitly ineligible scratch frames are not represented as packets.
Actual count/order faults are detected and recover after restoration. Default,
fallback, offline, strict and Apple/Windows compilation gates pass.

The measured representation removes a 24-byte vector header and its actual
four-byte-per-tile capacity. Linked text falls 368 bytes; default rodata grows
128 bytes and core grows 12 lines relative to its own shipping baseline.
The reverse-visit helper grows 11 bytes, despite smaller render/bin bodies and
fixed frames. No timing or hardware performance claim is made.

Review found a stronger descending-cursor formulation: the write cursor and
low remaining count can decrement in one subtraction, avoiding full count
reconstruction per reference. It is under separate qualification at
1c97566cf0a7140d4f258deab136342a609d5755. The provisional two-file Main
application of 6bf was reversed before any compiler reader or commit; shipping
remains unchanged. This archive preserves the exact predecessor and its costs.
