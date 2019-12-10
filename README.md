# Biru

An online manga reading utility

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Wait, what does `biru` mean?

Originally, I came up with `kuchibiru` (唇), which means `lips` in Japanese, but I intentionally dropped the kuchi (口) part, because this is hentai 🤫

### Dependencies

In order to run, you must have these software installed, depends on your GNU/Linux distro, package names may vary

```sh
# on Archlinux
sudo pacman -S --needed gtk3 gvfs libsoup vala meson
```

### Building

Clone this project

```sh
git clone https://github.com/l4rzy/biru.git
```

Go to project folder, and type

```sh
cd biru
meson b
```

Finally call ninja to build

```sh
cd b
ninja
```

Run with

```sh
./biru
```

## Contributing

Check out [CONTRIBUTING.md](CONTRIBUTING.md)

## Authors

* **l4rzy** - *Initial work* -

## License

GPLv3
