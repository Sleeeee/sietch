blueprints = custom_target('blueprints',
  input: files(
    'hyprland.blp',
    'clock.blp',
    'wireplumber.blp',
    'network.blp',
    'battery.blp',
    'bar.blp'
  ),
  output: '.',
  command: [
    find_program('blueprint-compiler'),
    'batch-compile',
    '@OUTPUT@',
    '@CURRENT_SOURCE_DIR@',
    '@INPUT@',
  ],
)

