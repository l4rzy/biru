project('biru', ['vala', 'c'],
    version : '0.0.1',
    license: 'GPL-3.0'
)

c_args = [
    '-fuse-ld=lld'
]

sources = files(
    'main.vala'
)

subdir('service')
subdir('ui')
subdir('utils')

dependencies = [
    dependency('gobject-2.0'),
    dependency('glib-2.0'),
    dependency('gtk+-3.0'),
    dependency('json-glib-1.0'),
    dependency('libsoup-2.4'),
    meson.get_compiler('vala').find_library('posix'),
]

e = executable('biru',
    sources: sources,
    c_args: c_args,
    dependencies: dependencies,
    install : false
)
