subdir('ui')
subdir('scss')

gresource = gnome.compile_resources('sietch',
  'sietch.gresource.xml',
  source_dir: meson.current_build_dir(),
  c_name: 'sietch',
  dependencies: [blueprints, scss],
)
