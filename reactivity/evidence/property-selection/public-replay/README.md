# Ordinary public Window replay

Shipping source `021dcb5d29a84269c896674823b3a508d7b22d97`.
`property_editor` is built with desktop,x11,wayland,gpui_canvas/parallel, offline
and locked. The frozen executable hash/bytes are in executable.json. Run the
unmodified example with --cpu; no startup instrumentation or native-host seeding
is added. The standalone client owns its Xvfb and private session/bus Registry:

```sh
source /tmp/gpui-native-env.sh
dbus-run-session -- python3 client.py /path/to/property_editor \
  --xvfb /nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb \
  --launcher /nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher \
  --output result.json --display :163
```

Use an unused display. Python3, busctl and the inherited native library paths are
required. Both AT-SPI Registry and provider are real. Client uses exposed checkbox
Action to enable inspection, library button Action to select its own root,
EditableText.SetTextContents to enter193.25, Apply, Inherit and Refresh actions.
It verifies acknowledged draft text/character extents and actual application
width enlargement/restoration. No owner.update, private model read, synthetic
ACK, callback hook or application instrumentation appears in this client.
Projection is acknowledged because the native bridge publishes P after actual
presentation. This is an external functional proof, not a timing measurement.

Two initial client failures remain verbatim: busctl parsed GetText's -1 offset as
an option until an explicit -- separator was added; GetCharacterExtents returns
four flat values whereas Component.GetExtents returns one struct. Only the
external client changed. The same frozen application passes qualified.json.
All child processes are terminated/waited in finally; the private session bus
is retired by dbus-run-session. This is distinct from the lower-layer native
pointer/driver pixel proof.
