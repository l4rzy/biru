# Biru

An online manga reading utility

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### NSFW warning

A part of this project promotes some NSFW contents, you've been warned. Support for other manga providers has been considered, but for now only [NHentai](https://nhentai.net) is supported.

### But wait, what does `biru` mean?

Originally, I came up with `kuchibiru` (唇), which means `lips` in Japanese, but I intentionally dropped the kuchi (口) part, because this is hentai 🤫

### Dependencies

In order to run, you must have `gtk3` and `libsoup` installed, depends on your GNU/Linux distro, package names may vary. Vala compiler and meson are required to build, not to run.

```sh
# on Archlinux
sudo pacman -S --needed gtk3 libsoup vala meson
```

### Building

Clone this project

```sh
git clone https://github.com/l4rzy/biru.git
```

Go to project folder, and call meson to generate build files in a new directory (`b` in this case)

```sh
cd biru
meson b
```

Go to build folder and call ninja to build

```sh
cd b
ninja
```

Run with

```sh
./biru
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md)

## Authors

* **l4rzy** - *Initial work* -

## Acknowledges

* [vala-gkt-examples](https://github.com/gerito1/vala-gtk-examples) - exellent sample code
* [official vala tutorial](https://wiki.gnome.org/Projects/Vala) - good sample code for async
* [hackup](https://github.com/mdh34/hackup) - nice sample code
* [fondo](https://github.com/calo001/fondo) - ui inspiration and some code tricks

## License

GPLv3
