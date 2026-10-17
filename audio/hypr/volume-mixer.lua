-- Volume mixer (JBL + Projector, per-device sliders). Press again to close.
-- GTK_THEME loads a pavucontrol-only theme that highlights the default device.
o.bind("SUPER + ALT + A", "Volume mixer", "pkill -x pavucontrol || GTK_THEME=Pavucontrol-Highlight pavucontrol --tab=3")

-- Opens floating, centered, and tall enough that the device list doesn't scroll.
o.window("org.pulseaudio.pavucontrol", { float = true, center = true, size = { 900, 1000 } })
