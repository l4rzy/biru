project('biru', ['vala', 'c'],
    version : '0.0.1',
    license: 'GPL-3.0'
)

c_args = [
    '-O0'
]

gnome = import('gnome')
biru_resource = gnome.compile_resources(
    'brsrc', 'ui/resources/biru.gresource.xml',
    source_dir: 'ui/resources',
    c_name: 'brsrc'
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
    biru_resource,
    sources: sources,
    c_args: c_args,
    dependencies: dependencies,
    install : false
)
