// Standalone numerical check for the variable-width Figma inner-border gradient.
// Run with: node experiment.mjs
//
// The cubic is a standard quarter-circle Bézier approximation. Its closest-point
// distance and normal are evaluated independently; the curvature correction is
// compared with central finite differences of the full inner field.

const P0 = [1, 0];
const P1 = [1, 0.55228475];
const P2 = [0.55228475, 1];
const P3 = [0, 1];

const add = (a, b) => [a[0] + b[0], a[1] + b[1]];
const sub = (a, b) => [a[0] - b[0], a[1] - b[1]];
const mul = (a, scalar) => [a[0] * scalar, a[1] * scalar];
const dot = (a, b) => a[0] * b[0] + a[1] * b[1];
const length = (a) => Math.hypot(a[0], a[1]);

function curve(t) {
  const u = 1 - t;
  return add(
    add(mul(P0, u ** 3), mul(P1, 3 * u * u * t)),
    add(mul(P2, 3 * u * t * t), mul(P3, t ** 3)),
  );
}

function firstDerivative(t) {
  const u = 1 - t;
  return add(
    add(mul(sub(P1, P0), 3 * u * u), mul(sub(P2, P1), 6 * u * t)),
    mul(sub(P3, P2), 3 * t * t),
  );
}

function secondDerivative(t) {
  return add(
    mul(add(sub(P2, mul(P1, 2)), P0), 6 * (1 - t)),
    mul(add(sub(P3, mul(P2, 2)), P1), 6 * t),
  );
}

function closestSample(point, mirror = [1, 1]) {
  // Reflect the query into the base quadrant, then reflect the outward normal
  // back. This mirrors both the curve and point without changing convex curvature.
  const basePoint = [point[0] * mirror[0], point[1] * mirror[1]];
  let t = 0;
  let bestSquaredDistance = Infinity;
  for (let index = 0; index <= 400; index++) {
    const candidate = index / 400;
    const delta = sub(curve(candidate), basePoint);
    const squaredDistance = dot(delta, delta);
    if (squaredDistance < bestSquaredDistance) {
      bestSquaredDistance = squaredDistance;
      t = candidate;
    }
  }

  for (let iteration = 0; iteration < 15; iteration++) {
    const q = curve(t);
    const tangent = firstDerivative(t);
    const acceleration = secondDerivative(t);
    const delta = sub(q, basePoint);
    const denominator = dot(tangent, tangent) + dot(delta, acceleration);
    if (Math.abs(denominator) < 1e-12) break;
    t = Math.max(
      0,
      Math.min(1, t - dot(delta, tangent) / denominator),
    );
  }

  const q = curve(t);
  const tangent = firstDerivative(t);
  const acceleration = secondDerivative(t);
  const speed = length(tangent);
  const unitTangent = mul(tangent, 1 / speed);
  const normal = [unitTangent[1], -unitTangent[0]];
  const delta = sub(basePoint, q);
  const signedDistance = length(delta) * (dot(delta, normal) >= 0 ? 1 : -1);
  const curvature = Math.abs(
    (tangent[0] * acceleration[1] - tangent[1] * acceleration[0]) /
      speed ** 3,
  );
  return {
    signedDistance,
    normal: [normal[0] * mirror[0], normal[1] * mirror[1]],
    curvature,
  };
}

let border = [3, 1];
let activeSides = [1, 0];

function effectiveWidth(normal) {
  return Math.hypot(border[0] * normal[0], border[1] * normal[1]) -
    0.5 * (1 - Math.hypot(activeSides[0] * normal[0], activeSides[1] * normal[1]));
}

function widthGradient(normal) {
  const borderNorm = Math.max(
    Math.hypot(border[0] * normal[0], border[1] * normal[1]),
    1e-15,
  );
  const activeNorm = Math.hypot(activeSides[0] * normal[0], activeSides[1] * normal[1]);
  return [
    (border[0] ** 2 * normal[0]) / borderNorm +
      (activeNorm > 1e-15 ? 0.5 * activeSides[0] ** 2 * normal[0] / activeNorm : 0),
    (border[1] ** 2 * normal[1]) / borderNorm +
      (activeNorm > 1e-15 ? 0.5 * activeSides[1] ** 2 * normal[1] / activeNorm : 0),
  ];
}

function innerField(point, mirror) {
  const sample = closestSample(point, mirror);
  return -(sample.signedDistance + effectiveWidth(sample.normal));
}

function compare(parameter, offset, mirror = [1, 1]) {
  const curveTangent = firstDerivative(parameter);
  const unitTangent = mul(curveTangent, 1 / length(curveTangent));
  const contourNormal = [unitTangent[1], -unitTangent[0]];
  const basePoint = add(curve(parameter), mul(contourNormal, offset));
  const point = [basePoint[0] * mirror[0], basePoint[1] * mirror[1]];
  const { signedDistance, normal, curvature } = closestSample(point, mirror);
  const tangent = [-normal[1], normal[0]];
  const gradWidth = widthGradient(normal);
  const widthTangent = dot(tangent, gradWidth);
  const curvatureAtOffset = curvature / (1 + curvature * signedDistance);
  const predicted = [
    -normal[0] - curvatureAtOffset * tangent[0] * widthTangent,
    -normal[1] - curvatureAtOffset * tangent[1] * widthTangent,
  ];

  const h = 1e-5;
  const finiteDifference = [
    (innerField(add(point, [h, 0]), mirror) - innerField(sub(point, [h, 0]), mirror)) / (2 * h),
    (innerField(add(point, [0, h]), mirror) - innerField(sub(point, [0, h]), mirror)) / (2 * h),
  ];
  return {
    error: length(sub(predicted, finiteDifference)),
    predicted,
    finiteDifference,
    curvature,
    signedDistance,
  };
}

const transform = [[4, 3.8], [0.3, 0.2]];
const determinant = transform[0][0] * transform[1][1] - transform[0][1] * transform[1][0];
const inverse = [
  [transform[1][1] / determinant, -transform[0][1] / determinant],
  [-transform[1][0] / determinant, transform[0][0] / determinant],
];
const screenGradient = (gradient) => [
  gradient[0] * inverse[0][0] + gradient[1] * inverse[1][0],
  gradient[0] * inverse[0][1] + gradient[1] * inverse[1][1],
];
const parameters = [0.1, 0.25, 0.5, 0.75, 0.9];
const offsets = [-0.08, 0, 0.08];
const quadrants = [
  [-1, -1],
  [-1, 1],
  [1, -1],
  [1, 1],
];

function runFixture(name, fixtureBorder, fixtureActiveSides, includeQuadrants) {
  border = fixtureBorder;
  activeSides = fixtureActiveSides;
  const fixtureQuadrants = includeQuadrants ? quadrants : [[1, 1]];
  let overallMaxError = 0;
  let overallMaxScreenError = 0;
  console.log(
    `fixture=${name} border=${border} active=${activeSides} total_samples=${fixtureQuadrants.length * parameters.length * offsets.length}`,
  );
  for (const mirror of fixtureQuadrants) {
    let maxError = 0;
    for (const parameter of parameters) {
      for (const offset of offsets) {
        const result = compare(parameter, offset, mirror);
        maxError = Math.max(maxError, result.error);
        overallMaxError = Math.max(overallMaxError, result.error);
        console.log(
          `  q=${mirror} t=${parameter.toFixed(2)} d=${offset >= 0 ? "+" : ""}${offset.toFixed(2)} ` +
            `k=${result.curvature.toFixed(3)} err=${result.error.toExponential(2)}`,
        );
      }
    }
    const strongShear = compare(0.4, 0.04, mirror);
    const screenError = length(
      sub(screenGradient(strongShear.predicted), screenGradient(strongShear.finiteDifference)),
    );
    maxError = Math.max(maxError, strongShear.error);
    overallMaxError = Math.max(overallMaxError, strongShear.error);
    overallMaxScreenError = Math.max(overallMaxScreenError, screenError);
    console.log(
      `  q=${mirror} strong_shear_local_error=${strongShear.error.toExponential(3)} ` +
        `screen_error=${screenError.toExponential(3)}`,
    );
  }
  console.log(
    `fixture_summary=${name} quadrants=${fixtureQuadrants.length} smooth_samples=${fixtureQuadrants.length * parameters.length * offsets.length} ` +
      `max_local_error=${overallMaxError.toExponential(3)} ` +
      `max_strong_shear_screen_error=${overallMaxScreenError.toExponential(3)}`,
  );
}

// Retain the mathematically valid generic fixture for an active-side mask that
// does not correspond to production border widths.
runFixture("generic_reference", [3, 1], [1, 0], false);
runFixture("production_b31_a11", [3, 1], [1, 1], true);
runFixture("production_b30_a10", [3, 0], [1, 0], true);
runFixture("production_b02_a01", [0, 2], [0, 1], true);
