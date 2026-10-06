// Deterministic differential check of a four-lane WGSL-style nearest-edge reduction
// against the current scalar top/right/bottom/left update sequence.
// Run with Node.js: node experiment.mjs

const f = Math.fround;
const add = (a, b) => f(a + b);
const sub = (a, b) => f(a - b);
const mul = (a, b) => f(a * b);
const min = (a, b) => (a < b ? a : b);
const max = (a, b) => (a > b ? a : b);
const clamp = (x, lo, hi) => min(max(x, lo), hi);
const sqrt = (x) => f(Math.sqrt(x));
const dot = (a, b) => add(mul(a[0], b[0]), mul(a[1], b[1]));
const bits = (value) => {
  const buffer = new ArrayBuffer(4);
  const view = new DataView(buffer);
  view.setFloat32(0, value, false);
  return view.getUint32(0, false);
};

function scalarSample(px, py, sx, sy, h, v) {
  let dx = sub(px, clamp(px, h[0], max(h[0], sub(sx, h[1]))));
  let dy = py;
  let best2 = add(mul(dx, dx), mul(dy, dy));
  let selected = 0;

  let candidateX = sub(px, sx);
  let candidateY = sub(py, clamp(py, v[1], max(v[1], sub(sy, v[2]))));
  let candidate2 = add(mul(candidateX, candidateX), mul(candidateY, candidateY));
  if (candidate2 < best2) {
    dx = candidateX;
    dy = candidateY;
    best2 = candidate2;
    selected = 1;
  }

  candidateX = sub(px, clamp(px, h[3], max(h[3], sub(sx, h[2]))));
  candidateY = sub(py, sy);
  candidate2 = add(mul(candidateX, candidateX), mul(candidateY, candidateY));
  if (candidate2 < best2) {
    dx = candidateX;
    dy = candidateY;
    best2 = candidate2;
    selected = 2;
  }

  candidateX = px;
  candidateY = sub(py, clamp(py, v[0], max(v[0], sub(sy, v[3]))));
  candidate2 = add(mul(candidateX, candidateX), mul(candidateY, candidateY));
  if (candidate2 < best2) {
    dx = candidateX;
    dy = candidateY;
    best2 = candidate2;
    selected = 3;
  }

  const normals = [[0, -1], [1, 0], [0, 1], [-1, 0]];
  const normal = normals[selected];
  const signed = dot([dx, dy], normal) >= 0 ? sqrt(best2) : f(-sqrt(best2));
  return { selected, best2, dx, dy, normal, signed };
}

function vectorReductionSample(px, py, sx, sy, h, v) {
  const starts = [h[0], v[1], h[3], v[0]];
  const ends = [h[1], v[2], h[2], v[3]];
  const high = [
    max(starts[0], sub(sx, ends[0])),
    max(starts[1], sub(sy, ends[1])),
    max(starts[2], sub(sx, ends[2])),
    max(starts[3], sub(sy, ends[3])),
  ];
  const along = [
    clamp(px, starts[0], high[0]),
    clamp(py, starts[1], high[1]),
    clamp(px, starts[2], high[2]),
    clamp(py, starts[3], high[3]),
  ];
  const dx = [sub(px, along[0]), sub(px, sx), sub(px, along[2]), px];
  const dy = [py, sub(py, along[1]), sub(py, sy), sub(py, along[3])];
  const distance2 = dx.map((x, i) => add(mul(x, x), mul(dy[i], dy[i])));
  const best2 = min(min(distance2[0], distance2[1]), min(distance2[2], distance2[3]));
  // First equality implements the old strict-< top/right/bottom/left tie priority.
  const selected = distance2.findIndex((distance) => distance === best2);
  const normals = [[0, -1], [1, 0], [0, 1], [-1, 0]];
  const normal = normals[selected];
  const deltaX = dx[selected];
  const deltaY = dy[selected];
  const signed = dot([deltaX, deltaY], normal) >= 0 ? sqrt(best2) : f(-sqrt(best2));
  return { selected, best2, dx: deltaX, dy: deltaY, normal, signed };
}

function sameF32(a, b) {
  return bits(a) === bits(b);
}

function equalSamples(a, b) {
  return a.selected === b.selected &&
    sameF32(a.best2, b.best2) &&
    sameF32(a.dx, b.dx) &&
    sameF32(a.dy, b.dy) &&
    sameF32(a.signed, b.signed) &&
    sameF32(a.normal[0], b.normal[0]) &&
    sameF32(a.normal[1], b.normal[1]);
}

const fixtures = [
  { name: "top_left_corner_tie", point: [0, 0], size: [100, 60], h: [0, 0, 0, 0], v: [0, 0, 0, 0] },
  { name: "bottom_right_corner_tie", point: [100, 60], size: [100, 60], h: [0, 0, 0, 0], v: [0, 0, 0, 0] },
  { name: "symmetric_equal_top_bottom", point: [50, 30], size: [100, 60], h: [0, 0, 0, 0], v: [0, 0, 0, 0] },
  { name: "collapsed_top_and_right", point: [68, 34], size: [100, 60], h: [70, 40, 90, 40], v: [50, 45, 55, 45] },
  { name: "overlapping_reaches", point: [50, 50], size: [100, 100], h: [80, 80, 80, 80], v: [80, 80, 80, 80] },
  { name: "zero_size", point: [0, 0], size: [0, 0], h: [0, 0, 0, 0], v: [0, 0, 0, 0] },
  { name: "negative_extents", point: [-5, 17], size: [20, 30], h: [-4, -3, -2, -1], v: [-6, -5, -4, -3] },
  { name: "overflowed_squared_distances", point: [3.0e38, -3.0e38], size: [3.0e38, 3.0e38], h: [0, 0, 0, 0], v: [0, 0, 0, 0] },
];

let mismatchCount = 0;
for (const fixture of fixtures) {
  const [px, py] = fixture.point.map(f);
  const [sx, sy] = fixture.size.map(f);
  const h = fixture.h.map(f);
  const v = fixture.v.map(f);
  const oldResult = scalarSample(px, py, sx, sy, h, v);
  const newResult = vectorReductionSample(px, py, sx, sy, h, v);
  const match = equalSamples(oldResult, newResult);
  if (!match) mismatchCount++;
  console.log(
    `fixture=${fixture.name} match=${match} old=${oldResult.selected}/${oldResult.signed} new=${newResult.selected}/${newResult.signed}`,
  );
}

let state = 0x6d2b79f5;
function randomU32() {
  state ^= state << 13;
  state ^= state >>> 17;
  state ^= state << 5;
  return state >>> 0;
}
function randomRange(minimum, maximum) {
  const unit = randomU32() / 0xffffffff;
  return f(minimum + (maximum - minimum) * unit);
}

const randomCases = 250_000;
for (let index = 0; index < randomCases; index++) {
  let px;
  let py;
  let sx;
  let sy;
  let h;
  let v;
  if (index % 8 === 0) {
    const sign = () => (randomU32() & 1 ? 1 : -1);
    const exponent = () => (randomU32() % 250) - 125;
    const magnitude = () => f(sign() * 2 ** exponent());
    px = magnitude(); py = magnitude(); sx = Math.abs(magnitude()); sy = Math.abs(magnitude());
    h = [magnitude(), Math.abs(magnitude()), magnitude(), Math.abs(magnitude())];
    v = [magnitude(), Math.abs(magnitude()), magnitude(), Math.abs(magnitude())];
  } else {
    px = randomRange(-1e5, 2e5);
    py = randomRange(-1e5, 2e5);
    sx = randomRange(0, 1e5);
    sy = randomRange(0, 1e5);
    h = Array.from({ length: 4 }, () => randomRange(0, 2e5));
    v = Array.from({ length: 4 }, () => randomRange(0, 2e5));
  }
  const oldResult = scalarSample(px, py, sx, sy, h, v);
  const newResult = vectorReductionSample(px, py, sx, sy, h, v);
  if (!equalSamples(oldResult, newResult)) {
    mismatchCount++;
    if (mismatchCount <= 5) {
      console.log(`mismatch=${index} old=${JSON.stringify(oldResult)} new=${JSON.stringify(newResult)}`);
    }
  }
}

console.log(`random_cases=${randomCases} seed=0x6d2b79f5 exact_mismatches=${mismatchCount}`);
