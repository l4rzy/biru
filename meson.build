project('biru', ['vala', 'c'],
    version : '0.0.1',
    license: 'GPL-3.0'
)

sources = files(
    'service/constants.vala',
    'service/service.vala',
    'service/models.vala',
    'service/serde.vala',
    'main.vala'
)

dependencies = [
    dependency('gobject-2.0'),
    dependency('glib-2.0'),
    dependency('granite'),
    dependency('gtk+-3.0'),
    dependency('json-glib-1.0'),
    dependency('libsoup-2.4'),
    meson.get_compiler('vala').find_library('posix'),
]

e = executable('biru',
    sources: sources,
    dependencies: dependencies,
    install : false
)
