The [resident-word spike](unadopted/README.md) is functionally qualified and
**unadopted**. It removes unchanged draw uploads without another retained
packet, and a deliberate residency fault is caught by actual pixel readback.
It adds 202 core code lines and may increase sparse queue writes. Timing,
linked application code size and the simpler uniform-layout alternative must
be resolved before integration. Only this evidence is imported into main.
