# scripts

* [Website](https://ronin-rb.dev)
* [Issues](https://github.com/ronin-rb/scripts/issues)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

A repository of useful setup scripts.

## What is Ronin?

[Ronin][website] is a free and Open Source [Ruby] toolkit for security research
and development. Ronin contains many different [CLI commands][ronin-synopsis]
and [Ruby libraries][ronin-rb] for a variety of security tasks, such as
encoding/decoding data, filter IPs/hosts/URLs, querying ASNs, querying DNS,
HTTP, [scanning for web vulnerabilities][ronin-vulns-synopsis],
[spidering websites][ronin-web-spider],
[install 3rd party repositories][ronin-repos-synopsis] of
[exploits][ronin-exploits] and/or
[payloads][ronin-payloads], [run exploits][ronin-exploits-synopsis],
[write new exploits][ronin-exploits-examples],
[managing local databases][ronin-db-synopsis],
[fuzzing data][ronin-fuzzer], and much more.

[Ruby]: https://www.ruby-lang.org/
[website]: https://ronin-rb.dev/
[ronin]: https://github.com/ronin-rb/ronin#readme
[ronin-synopsis]: https://github.com/ronin-rb/ronin#synopsis
[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
[ronin-repos-synopsis]: https://github.com/ronin-rb/ronin-repos#synopsis
[ronin-core]: https://github.com/ronin-rb/ronin-core#readme
[ronin-db]: https://github.com/ronin-rb/ronin-db#readme
[ronin-db-synopsis]: https://github.com/ronin-rb/ronin-db#synopsis
[ronin-fuzzer]: https://github.com/ronin-rb/ronin-fuzzer#readme
[ronin-web]: https://github.com/ronin-rb/ronin-web#readme
[ronin-web-server]: https://github.com/ronin-rb/ronin-web-server#readme
[ronin-web-spider]: https://github.com/ronin-rb/ronin-web-spider#readme
[ronin-web-user_agents]: https://github.com/ronin-rb/ronin-web-user_agents#readme
[ronin-code-asm]: https://github.com/ronin-rb/ronin-code-asm#readme
[ronin-code-sql]: https://github.com/ronin-rb/ronin-code-sql#readme
[ronin-payloads]: https://github.com/ronin-rb/ronin-payloads#readme
[ronin-exploits]: https://github.com/ronin-rb/ronin-exploits#readme
[ronin-exploits-synopsis]: https://github.com/ronin-rb/ronin-exploits#synopsis
[ronin-exploits-examples]: https://github.com/ronin-rb/ronin-exploits#examples
[ronin-vulns]: https://github.com/ronin-rb/ronin-vulns#readme
[ronin-vulns-synopsis]: https://github.com/ronin-rb/ronin-vulns#synopsis

## Features

* Installs [ronin] or sets up a local development environment.
* Optionally supports installing pre-release versions.
* Auto-detects the OS (supports Linux, macOS, and FreeBSD).
* Auto-detects the package manager (supports [apt], [dnf], [yum], [pacman],
  [zypper], [pkg], [macports], [brew]).
* Auto-installs any missing external dependencies via the package manager:
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
[Synopsis]: https://github.com/ronin-rb/ronin#synopsis
[GitHub]: https://github.com/ronin-rb/

[apt]: http://wiki.debian.org/Apt
[dnf]: https://fedoraproject.org/wiki/Features/DNF
[yum]: http://yum.baseurl.org/
[pacman]: https://wiki.archlinux.org/index.php/Pacman
[zypper]: https://en.opensuse.org/Portal:Zypper
[pkg]: https://wiki.freebsd.org/pkgng
[macports]: https://www.macports.org/
[brew]: http://brew.sh

[sqlite]: https://www.sqlite.org/index.html
[gcc]: http://gcc.gnu.org/
[make]: https://www.gnu.org/software/automake/
[ruby]: https://www.ruby-lang.org/
[rubygems]: https://github.com/rubygems/rubygems#readme
