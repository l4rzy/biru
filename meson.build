project('biru', ['vala', 'c'],
    version : '0.0.1',
    license: 'GPL-3.0'
)

c_args = [
    '-O0',
    '-g'
]

gnome = import('gnome')
biru_resources = gnome.compile_resources(
    'biru_resources', 'resources/biru.gresource.xml',
    source_dir: 'resources',
    c_name: 'biru_resources'
)

sources = files(
    'main.vala'
)

subdir('service')
subdir('ui')
subdir('utils')

dependencies = [
    dependency('gtk+-3.0'),
    dependency('json-glib-1.0'),
    dependency('libsoup-2.4'),
    meson.get_compiler('vala').find_library('posix'),
]

e = executable('biru',
    biru_resources,
    sources: sources,
    c_args: c_args,
    dependencies: dependencies,
    install : false
)
