# Biru

An online manga reading utility

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Dependencies

In order to run, you must have these software installed, depends on your GNU/Linux distro, it may vary

```sh
# on Archlinux
sudo pacman -S --needed gtk3 gvfs granite libsoup valac meson
```

### Building

Clone this project

```sh
git clone https://github.com/l4rzy/biru.git
```

Go to project folder, and type

```sh
meson b
```

Finally use ninja to build

```sh
cd b
ninja
```

Run with

```sh
./biru
```

## Contributing

WIP

## Authors

* **l4rzy** - *Initial work* -

## License

Haven't decided yet
