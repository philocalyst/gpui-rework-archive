// Native WebGL, one draw call. Rust supplies the evolving phase; this module
// only connects the browser's clock, visibility and interaction to the GPU.
import { gpuiWasm } from '../components/wasm-runtime.js';
const canvas = document.querySelector('canvas[data-field]');
const toggle = document.querySelector('[data-motion]');
const trigger = document.querySelector('[data-accelerate]');
if (canvas && toggle && trigger) {
  const reduced = matchMedia('(prefers-reduced-motion: reduce)');
  let paused = reduced.matches, hovering = false, focused = false;
  let frame = 0, last = 0, phaseValue = 4.8, energy = 0;
  const syncButton = () => {
    toggle.textContent = paused ? 'Play field ↗' : 'Pause field Ⅱ';
    toggle.setAttribute('aria-pressed', String(paused));
  };
  syncButton();
  try {
    const wasm = await gpuiWasm;
    const gl = canvas.getContext('webgl', { alpha: false, antialias: false, depth: false, powerPreference: 'low-power' });
    if (!gl) throw new Error('WebGL unavailable');
    function shader(type, source) {
      const value = gl.createShader(type);
      gl.shaderSource(value, source); gl.compileShader(value);
      if (!gl.getShaderParameter(value, gl.COMPILE_STATUS)) throw new Error('Shader compilation unavailable');
      return value;
    }
    const program = gl.createProgram();
    gl.attachShader(program, shader(gl.VERTEX_SHADER, 'attribute vec2 position;void main(){gl_Position=vec4(position,0.,1.);}'));
    gl.attachShader(program, shader(gl.FRAGMENT_SHADER, `precision mediump float;
      uniform vec2 resolution; uniform float phase; uniform float engagement;
      float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
      float noise(vec2 p){vec2 i=floor(p),f=fract(p);f=f*f*(3.-2.*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
      void main(){
        vec2 p=(gl_FragCoord.xy-.5*resolution)/resolution.y;
        float t=phase;
        float twist=.65+.14*sin(t*.5);
        p=mat2(cos(twist),-sin(twist),sin(twist),cos(twist))*p;
        float n=noise(p*3.+vec2(t*.12,-t*.08));
        float wave=p.x*3.6+sin(p.y*4.+t*.18)*.8+sin(p.y*1.7-t*.16)*.9+n*.8;
        float stripe=.5+.5*sin(wave*9.+t);
        float filament=pow(stripe,4.);
        float cloud=noise(p*5.+t*.035);
        vec2 cell=fract(gl_FragCoord.xy/3.5)-.5;
        float dotMask=1.-smoothstep(.20,.43,length(cell));
        float light=filament*(.5+cloud*.5)*dotMask;
        float hue=smoothstep(-.6,.8,sin(wave*1.25+t*.18));
        // GPU shader colors are linear RGB; authored CSS colors use OKLCH.
        vec3 dark=vec3(.023,.018,.045);
        vec3 violet=vec3(.31,.10,.60);
        vec3 acid=vec3(.55,.76,.16);
        vec3 ink=mix(violet,acid,hue);
        vec3 color=dark+ink*light*(.70+engagement*.22);
        float scan=.93+.07*sin(gl_FragCoord.y*1.57);
        color*=scan;
        color+=vec3(hash(gl_FragCoord.xy)*.012);
        gl_FragColor=vec4(color,1.);
      }`));
    gl.linkProgram(program);
    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) throw new Error('Shader linking unavailable');
    gl.useProgram(program);
    const buffer=gl.createBuffer();gl.bindBuffer(gl.ARRAY_BUFFER,buffer);
    gl.bufferData(gl.ARRAY_BUFFER,new Float32Array([-1,-1,3,-1,-1,3]),gl.STATIC_DRAW);
    const position=gl.getAttribLocation(program,'position');gl.enableVertexAttribArray(position);gl.vertexAttribPointer(position,2,gl.FLOAT,false,0,0);
    const resolution=gl.getUniformLocation(program,'resolution'), phase=gl.getUniformLocation(program,'phase'), power=gl.getUniformLocation(program,'engagement');
    function draw(now=0){
      frame=0;
      if(last && now-last<32 && !paused){frame=requestAnimationFrame(draw);return;}
      const dt=last ? Math.min((now-last)/1000,.08) : 0;last=now;
      if(!paused){energy+=((hovering||focused?1:0)-energy)*Math.min(1,dt*4);phaseValue+=wasm.field_phase(dt,energy);}
      const ratio=Math.min(devicePixelRatio,1),width=Math.max(1,Math.round(innerWidth*ratio)),height=Math.max(1,Math.round(innerHeight*ratio));
      if(canvas.width!==width||canvas.height!==height){canvas.width=width;canvas.height=height;gl.viewport(0,0,width,height);}
      gl.uniform2f(resolution,width,height);gl.uniform1f(phase,phaseValue);gl.uniform1f(power,energy);
      gl.drawArrays(gl.TRIANGLES,0,3);
      if(!paused&&!document.hidden)frame=requestAnimationFrame(draw);
    }
    function resume(){if(!frame){last=0;frame=requestAnimationFrame(draw);}}
    toggle.hidden=false;
    toggle.addEventListener('click',()=>{paused=!paused;syncButton();if(paused){cancelAnimationFrame(frame);frame=0;}else resume();});
    reduced.addEventListener('change',e=>{paused=e.matches;syncButton();cancelAnimationFrame(frame);frame=0;resume();});
    trigger.addEventListener('pointerenter',()=>{hovering=true;});trigger.addEventListener('pointerleave',()=>{hovering=false;});
    trigger.addEventListener('focus',()=>{focused=true;});trigger.addEventListener('blur',()=>{focused=false;});
    new ResizeObserver(()=>{if(paused)draw();}).observe(document.documentElement);
    document.addEventListener('visibilitychange',()=>{if(document.hidden){cancelAnimationFrame(frame);frame=0;}else resume();});
    canvas.addEventListener('webglcontextlost',event=>{event.preventDefault();cancelAnimationFrame(frame);toggle.hidden=true;canvas.hidden=true;});
    draw();
  } catch {
    toggle.hidden=true;
    canvas.hidden=true;
  }
}
