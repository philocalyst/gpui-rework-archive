// The ocean: one WebGL draw call behind every page. Rust supplies the clock
// and the swell; this module only connects the browser's time, visibility and
// pointer to the GPU, and lets the hero's paper edge ride the same swell.
import { gpuiWasm } from '../components/wasm-runtime.js';

const canvas = document.querySelector('canvas[data-field]');
const toggle = document.querySelector('[data-motion]');
const trigger = document.querySelector('[data-accelerate]');
const hero = document.querySelector('.hero');
const marquee = document.querySelector('.undertow');

if (canvas && toggle) {
  const reduced = matchMedia('(prefers-reduced-motion: reduce)');
  let paused = reduced.matches, hovering = false, focused = false;
  let frame = 0, last = 0, phaseValue = 3.2, energy = 0, tick = 0;
  const syncButton = () => {
    toggle.textContent = paused ? 'Set the water moving' : 'Still the water';
    toggle.setAttribute('aria-pressed', String(paused));
    if (marquee) paused ? marquee.pauseAnimations() : marquee.unpauseAnimations();
  };
  syncButton();
  try {
    const wasm = await gpuiWasm;
    const gl = canvas.getContext('webgl', { alpha: false, antialias: false, depth: false, powerPreference: 'low-power' });
    if (!gl) throw new Error('WebGL unavailable');
    const shader = (type, source) => {
      const value = gl.createShader(type);
      gl.shaderSource(value, source); gl.compileShader(value);
      if (!gl.getShaderParameter(value, gl.COMPILE_STATUS)) throw new Error(gl.getShaderInfoLog(value) || 'Shader compilation unavailable');
      return value;
    };
    const program = gl.createProgram();
    gl.attachShader(program, shader(gl.VERTEX_SHADER, 'attribute vec2 position;void main(){gl_Position=vec4(position,0.,1.);}'));
    gl.attachShader(program, shader(gl.FRAGMENT_SHADER, `precision mediump float;
      uniform vec2 resolution; uniform float phase; uniform float engagement;
      float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
      float noise(vec2 p){vec2 i=floor(p),f=fract(p);f=f*f*(3.-2.*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
      void main(){
        vec2 uv=gl_FragCoord.xy/resolution;
        float aspect=resolution.x/resolution.y;
        float t=phase;
        // Depth contours: the same swell as the Rust module, stacked down the page.
        float x=uv.x*aspect;
        float swell=sin(x*3.6+t)*.55+sin(x*7.2-t*.7)*.3+sin(x*14.4+t*1.9)*.15;
        float drift=noise(vec2(x*1.4,uv.y*2.+t*.08))*.9;
        float depth=uv.y*11.+swell+drift;
        float d=abs(fract(depth)-.5);
        float contour=smoothstep(.055,.0,d);
        float glow=smoothstep(.42,.0,d)*.16;
        float dots=step(.92,noise(gl_FragCoord.xy*.5+t))*.06*(1.-uv.y);
        vec3 abyss=vec3(.018,.036,.085);
        vec3 lagoon=vec3(.22,.72,.66);
        vec3 coral=vec3(.93,.34,.22);
        float warm=smoothstep(-.4,.9,sin(depth*.31+t*.22+x*.7));
        vec3 ink=mix(lagoon,coral,warm*(.1+.5*engagement));
        float deep=.35+.65*(1.-uv.y);
        vec3 color=abyss+ink*(contour*deep*(.5+.5*engagement)+glow*deep)+vec3(dots);
        color*=.82+.36*(1.-uv.y);
        color+=hash(gl_FragCoord.xy+t)*.012;
        gl_FragColor=vec4(color,1.);
      }`));
    gl.linkProgram(program);
    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) throw new Error('Shader linking unavailable');
    gl.useProgram(program);
    const buffer = gl.createBuffer(); gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 3, -1, -1, 3]), gl.STATIC_DRAW);
    const position = gl.getAttribLocation(program, 'position'); gl.enableVertexAttribArray(position); gl.vertexAttribPointer(position, 2, gl.FLOAT, false, 0, 0);
    const resolution = gl.getUniformLocation(program, 'resolution'), phase = gl.getUniformLocation(program, 'phase'), power = gl.getUniformLocation(program, 'engagement');
    function draw(now = 0) {
      frame = 0;
      if (last && now - last < 32 && !paused) { frame = requestAnimationFrame(draw); return; }
      const dt = last ? Math.min((now - last) / 1000, .08) : 0; last = now;
      if (!paused) { energy += ((hovering || focused ? 1 : 0) - energy) * Math.min(1, dt * 4); phaseValue += wasm.field_phase(dt, energy); }
      const ratio = Math.min(devicePixelRatio, 1), width = Math.max(1, Math.round(innerWidth * ratio)), height = Math.max(1, Math.round(innerHeight * ratio));
      if (canvas.width !== width || canvas.height !== height) { canvas.width = width; canvas.height = height; gl.viewport(0, 0, width, height); }
      gl.uniform2f(resolution, width, height); gl.uniform1f(phase, phaseValue); gl.uniform1f(power, energy);
      gl.drawArrays(gl.TRIANGLES, 0, 3);
      // The hero sheet's top edge rides the swell too, at half rate.
      if (hero && (tick++ & 1) === 0) hero.style.setProperty('--swell', `${(wasm.swell(0.5, phaseValue) * 60).toFixed(1)}px`);
      if (!paused && !document.hidden) frame = requestAnimationFrame(draw);
    }
    function resume() { if (!frame) { last = 0; frame = requestAnimationFrame(draw); } }
    toggle.hidden = false;
    toggle.addEventListener('click', () => { paused = !paused; syncButton(); if (paused) { cancelAnimationFrame(frame); frame = 0; } else resume(); });
    reduced.addEventListener('change', (e) => { paused = e.matches; syncButton(); cancelAnimationFrame(frame); frame = 0; resume(); });
    if (trigger) {
      trigger.addEventListener('pointerenter', () => { hovering = true; }); trigger.addEventListener('pointerleave', () => { hovering = false; });
      trigger.addEventListener('focus', () => { focused = true; }); trigger.addEventListener('blur', () => { focused = false; });
    }
    new ResizeObserver(() => { if (paused) draw(); }).observe(document.documentElement);
    document.addEventListener('visibilitychange', () => { if (document.hidden) { cancelAnimationFrame(frame); frame = 0; } else resume(); });
    canvas.addEventListener('webglcontextlost', (event) => { event.preventDefault(); cancelAnimationFrame(frame); toggle.hidden = true; canvas.hidden = true; });
    draw();
  } catch (error) {
    console.info('Ocean shader unavailable; the CSS sea remains.', error);
    toggle.hidden = true;
    canvas.hidden = true;
  }
}
