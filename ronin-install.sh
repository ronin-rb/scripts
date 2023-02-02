#!/usr/bin/env bash

ronin_install_version="0.1.0"

gem="gem"
gem_opts=(--no-format-executable)

#
# Prints a log message.
#
function log()
{
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[32m>>>\x1b[0m \x1b[1m$1\x1b[0m"
	else
		echo ">>> $1"
	fi
}

#
# Prints a warn message.
#
function warn()
{
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[33m***\x1b[0m \x1b[1m$1\x1b[0m" >&2
	else
		echo "*** $1" >&2
	fi
}

#
# Prints an error message.
#
function error()
{
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[31m!!!\x1b[0m \x1b[1m$1\x1b[0m" >&2
	else
		echo "!!! $1" >&2
	fi
}

#
# Prints an error message and exits with -1.
#
function fail()
{
	error "$@"
	exit -1
}

#
# Checks that $LANG is set correctly.
#
function check_lang()
{
	if [[ "$LANG" == "C" ]]; then
		error "ruby will not work properly with LANG=C"
		fail "Please set LANG to en_US.UTF-8 or another UTF-8 language"
	fi
}

#
# Sets os_platform and os_arch.
#
function detect_os()
{
	os_platform="$(uname -s)"
	os_arch="$(uname -m)"
}

#
# Don't use sudo if already root.
#
function detect_sudo()
{
	if (( UID == 0 )); then sudo=""
	else                    sudo="sudo"
	fi
}

#
# Auto-detect the package manager.
#
function detect_package_manager()
{
	case "$os_platform" in
		Linux)
			if [[ -f /etc/redhat-release ]]; then
				if   command -v dnf >/dev/null; then
					package_manager="dnf"
				elif command -v yum >/dev/null; then
					package_manager="yum"
				fi
			elif [[ -f /etc/debian_version ]]; then
				if command -v apt-get >/dev/null; then
					package_manager="apt"
				fi
			elif [[ -f /etc/SuSE-release ]]; then
				if command -v zypper >/dev/null; then
					package_manager="zypper"
				fi
			elif [[ -f /etc/arch-release ]]; then
				if command -v pacman >/dev/null; then
					package_manager="pacman"
				fi
			elif [[ -f /etc/os-release ]]; then
				if command -v pacman >/dev/null; then
					package_manager="pacman"
				elif command -v zypper >/dev/null; then
					package_manager="zypper"
				fi
			fi
			;;
		Darwin)
			if   command -v brew >/dev/null; then
				package_manager="brew"
			elif command -v port >/dev/null; then
				package_manager="port"
			fi
			;;
		*BSD)
			if command -v pkg >/dev/null; then
				package_manager="pkg"
			fi
			;;
	esac
}

function detect_ruby_version()
{
	if command -v ruby >/dev/null; then
		ruby_version="$(ruby -e 'print RUBY_VERSION')"
	fi
}

function detect_system()
{
	check_lang
	detect_os
	detect_sudo

	if [[ -z "$package_manager" ]]; then
		detect_package_manager
	fi

	detect_ruby_version
}

function detect_rubygems_install_dir()
{
	local gem_home="$(gem env gemdir)"

	if (( UID == 0 )); then
		gem_opts+=(--no-user-install)
	elif [[ -d "$gem_home" ]] && [[ ! -w "$gem_home" ]]; then
		gem="sudo $gem"
		gem_opts+=(--no-user-install)
	fi
}

#
# Installs a list of package names using the detected package manager.
#
function install_packages()
{
	case "$package_manager" in
		apt)	$sudo apt-get install -y "$@" || return $? ;;
		dnf|yum)$sudo $package_manager install -y "$@" || return $?     ;;
		port)   $sudo port install "$@" || return $?       ;;
		pkg)	$sudo pkg install -y "$@" || return $?     ;;
		brew)
			local brew_owner="$(/usr/bin/stat -f %Su "$(command -v brew)")"
			sudo -u "$brew_owner" brew install "$@" ||
			sudo -u "$brew_owner" brew upgrade "$@" || return $?
			;;
		pacman)
			local missing_pkgs=($(pacman -T "$@"))

			if (( ${#missing_pkgs[@]} > 0 )); then
				$sudo pacman -Sy --noconfirm "${missing_pkgs[@]}" || return $?
			fi
			;;
		zypper) $sudo zypper -n in -l $* || return $? ;;
		"")	warn "Could not determine Package Manager. Proceeding anyway." ;;
	esac
}

#
# Installs ruby via homebrew and configures it.
#
function homebrew_install_ruby()
{
	install_packages ruby
	brew pin ruby

	# make the homebrew ruby the default ruby for the script
	PATH="$(brew --prefix ruby)/bin:$PATH"
	hash -r

	# make the homebrew ruby the default ruby for zshrc
	cat >> ~/.zshrc <<CONFIG
PATH="\$(brew --prefix ruby)/bin:\$PATH"
PATH="\$(gem env gemdir)/bin:\$PATH"
CONFIG
}

#
# Installs git, if it's not installed.
#
function auto_install_ruby()
{
	# check if ruby-3.x is already installed
	if [[ ! "$ruby_version" == "3."* ]]; then
		log "Installing ruby 3.x ..."
		case "$package_manager" in
			brew)		homebrew_install_ruby ;;
			dnf|yum)	install_packages ruby-devel ruby-bundled-gems ;;
			zypper)		install_packages ruby-devel ;;
			apt)		install_packages ruby-full ;;
			pacman)		install_packages community/ruby ;;
			*)		install_packages ruby ;;
		esac || fail "Failed to install ruby!"
	fi

	auto_install_rubygems
}

function auto_install_rubygems()
{
	if ! command -v gem >/dev/null; then
		log "Installing rubygems ..."
		case "$package_manager" in
			dnf|yum)	install_packages rubygems ;;
			pacman)		install_packages community/rubygems ;;
			*)
				fail "rubygems was not installed along with ruby. Aborting!"
				;;
		esac
	fi

	detect_rubygems_install_dir
}

function auto_install_gcc()
{
	if ! command -v cc >/dev/null; then
		log "Installing gcc ..."
		install_packages gcc || fail "Failed to install gcc!"
	fi
}

function auto_install_gpp()
{
	if ! command -v c++ >/dev/null; then
		log "Installing g++ ..."
		case "$package_manager" in
			dnf|yum)	install_packages gcc-g++ ;;
			zypper)		install_packages gcc-c++ ;;
			*)		install_packages g++ ;;
		esac || fail "Failed to install g++!"
	fi
}

function auto_install_make()
{
	if ! command -v make >/dev/null; then
		log "Install make ..."
		install_packages make || fail "Failed to install make!"
	fi
}

function print_usage()
{
	cat <<USAGE
usage: ./ronin-install.sh [OPTIONS]

Options:
	    --package-manager [apt|dnf|yum|pacman|zypper|brew|pkg|port]
	    			Sets the package manager to use
	    --pre		Enables installing pre-release versions
	-V, --version		Prints the version
	-h, --help		Prints this message

USAGE
}

function parse_options()
{
	while [[ $# -gt 0 ]]; do
		case "$1" in
			--pre)
				prerelease="true"
				gem_opts+=(--prerelease)
				shift
				;;
			--package-manager)
				package_manager="$2"
				shift 2
				;;
			-V|--version)
				echo "ronin-install: $ronin_install_version"
				exit
				;;
			-h|--help)
				print_usage
				exit
				;;
			-*)
				echo "ronin-install: unrecognized option $1" >&2
				return 1
				;;
			*)
				echo "ronin-install: additional arguments not allowed" >&2
				return 1
				;;
		esac
	done
}

parse_options "$@" || exit $?
detect_system
auto_install_gcc
auto_install_gpp
auto_install_make
auto_install_ruby

function install_dependencies()
{
	case "$package_manager" in
		dnf|yum)libraries=(readline-devel sqlite-devel) ;;
		zypper)	libraries=(readline-devel sqlite3-devel) ;;
		apt)	libraries=(libreadline-dev libsqlite3-dev) ;;
		*)	libraries=(readline sqlite) ;;
	esac

	log "Installing external dependencies ..."
	install_packages "${libraries[@]}" || \
	  warn "Failed to install external dependencies. Proceeding anyways."
}

install_dependencies

if ! command -v ronin >/dev/null; then
	if [[ "$prerelease" == "true" ]]; then
		log "Installing ronin pre-release. This may take a while ..."
	else
		log "Installing ronin. This may take a while ..."
	fi

	$gem install ${gem_opts[@]} ronin

	log "ronin is now fully installed!"
else
	if [[ "$prerelease" == "true" ]]; then
		log "Updating ronin to the latest pre-release. This may take a while ..."
	else
		log "Updating ronin to the latest version. This may take a while ..."
	fi

	$gem update ${gem_opts[@]} ronin

	log "ronin has successfully been upgraded!"
fi

if [[ ! "$ruby_version" == "3."* ]] && [[ "$package_manager" == "brew" ]]; then
	log "Ruby ${ruby_version} was installed via Homebrew."
	log "You will need to restart your shell or open a new terminal."
fi
