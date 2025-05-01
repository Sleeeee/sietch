sass = find_program('sass')
scss_files = files(
  '_variables.scss',
  '_clock.scss',
  '_bar.scss',
  'main.scss',
)

scss = custom_target('scss',
  input: 'main.scss',
  output: 'style.css',
  command: [sass, '@INPUT@', '@OUTPUT@'],
  depend_files: scss_files,
)
