app_vala_sources = files(
  'hyprland.vala',
  'clock.vala',
  'theme.vala',
  'wireplumber.vala',
  'bluetooth.vala',
  'network.vala',
  'battery.vala',
  'bar.vala',
  'application.vala',
  'main.vala'
)

app_deps = [
  dependency('gtk4'),
  dependency('gtk4-layer-shell-0'),
  dependency('libadwaita-1'),
  dependency('libnm'),
  dependency('astal-4-4.0'),
  dependency('astal-io-0.1'),
  dependency('astal-hyprland-0.1'),
  dependency('astal-wireplumber-0.1'),
  dependency('astal-bluetooth-0.1'),
  dependency('astal-network-0.1'),
  dependency('astal-battery-0.1')
]

subdir('lib')

executable('sietch',
  app_vala_sources,
  gresource,
  dependencies: app_deps,
  link_args: ['-lm'],
  install: false
)
