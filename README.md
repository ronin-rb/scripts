# scripts

* [Website](https://ronin-rb.dev)
* [Issues](https://github.com/ronin-rb/scripts/issues)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

A repository of useful shell scripts.

## Features

* Installs [ronin] or sets up a local development environment.
* Optionally supports installing pre-releases.
* Auto-detects the OS (supports Linux, macOS, and FreeBSD).
* Auto-detects the package manager (supports [apt], [dnf], [yum], [pacman],
  [zypper], [pkg], [macports], [brew]).
* Auto-installs any missing external dependencies via the package manager:
  * [libreadline]
  * [libxml2]
  * [libxslt][libxslt]
  * [libsqlite3][sqlite]
  * [ruby-3.x][ruby]
  * [rubygems]
  * [gcc]
  * [make]

## ronin-install.sh

A script that installs all of [ronin], including external dependencies.

### curl && bash

Copy and paste the following command into the terminal:

```shell
curl -o ronin-install.sh https://raw.githubusercontent.com/ronin-rb/scripts/main/ronin-install.sh && bash ronin-install.sh
```

### wget && bash

If you have `wget` installed instead of `curl`, copy and paste the following
command into the terminal:

```shell
wget -O ronin-install.sh https://raw.githubusercontent.com/ronin-rb/scripts/main/ronin-install.sh && bash ronin-install.sh
```

## ronin-dev.sh

A script that sets up a local [ronin-rb] development environment.

### curl && bash

Copy and paste the following command into the terminal:

```shell
curl -o ronin-dev.sh https://raw.githubusercontent.com/ronin-rb/scripts/main/ronin-dev.sh && bash ronin-dev.sh
```

### wget && bash

If you have `wget` installed instead of `curl`, copy and paste the following
command into the terminal:

```shell
wget -O ronin-dev.sh https://raw.githubusercontent.com/ronin-rb/scripts/main/ronin-dev.sh && bash ronin-dev.sh
```

[ronin-rb]: https://github.com/ronin-rb/
[ronin]: https://github.com/ronin-rb/ronin#readme

[apt]: http://wiki.debian.org/Apt
[dnf]: https://fedoraproject.org/wiki/Features/DNF
[yum]: http://yum.baseurl.org/
[pacman]: https://wiki.archlinux.org/index.php/Pacman
[zypper]: https://en.opensuse.org/Portal:Zypper
[pkg]: https://wiki.freebsd.org/pkgng
[macports]: https://www.macports.org/
[brew]: http://brew.sh

[libreadline]: https://tiswww.case.edu/php/chet/readline/rltop.html
[sqlite]: https://www.sqlite.org/index.html
[libxml2]: https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home
[libxslt]: http://xmlsoft.org/libxslt/index.html
[gcc]: http://gcc.gnu.org/
[make]: https://www.gnu.org/software/automake/
[ruby]: https://www.ruby-lang.org/
