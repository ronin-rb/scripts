#!/usr/bin/env bash

bundler_version="~> 2.0"

github_org="ronin-rb"
github_base_uri="https://github.com/$github_org"
github_repos=(
	ronin-support
	ronin
	ronin-web
	ronin-sql
	ronin-asm
	ronin-exploits
	ronin-db
)

src_dir="$HOME/src"
ronin_src_dir="${src_dir}/${github_org}"

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

function detect_system()
{
	detect_os
	detect_sudo
	detect_package_manager
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
				$sudo pacman -S "${missing_pkgs[@]}" || return $?
			fi
			;;
		zypper) $sudo zypper -n in -l $* || return $? ;;
		"")	warn "Could not determine Package Manager. Proceeding anyway." ;;
	esac
}

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
# Prints an error message and exists with -1.
#
function fail()
{
	error "$@"
	exit -1
}

#
# Installs git, if it's not installed.
#
function auto_install_git()
{
	if ! command -v git >/dev/null; then
		log "Installing git ..."
		install_packages git || fail "Failed to install git!"
	fi
}

#
# Installs git, if it's not installed.
#
function auto_install_ruby()
{
	if ! command -v ruby >/dev/null; then
		log "Installing ruby ..."
		case "$package_manager" in
			dnf|yum)	install_packages ruby-devel ;;
			apt)		install_packages ruby-full ;;
			*)		install_packages ruby ;;
		esac || fail "Failed to install ruby!"
	fi
}

#
# Installs bundler, if it's not installed.
#
function auto_install_bundler()
{
	if ! command -v bundle >/dev/null; then
		log "Installing bundler ..."
		sudo gem install bundler -v "$bundler_version" ||
			fail "Failed to install bundler!"
	fi
}

detect_system
auto_install_git
auto_install_ruby
auto_install_bundler

mkdir -p "$ronin_src_dir"
pushd "$ronin_src_dir" >/dev/null

for repo in "${github_repos[@]}"; do
	github_uri="${github_base_uri}/${repo}.git"
	dest_dir="${ronin_src_dir}/${repo}"

	if [[ -d  "$dest_dir" ]]; then
		warn "Clone ${dest_dir} already exists. Skipping."
	else
		log "Cloning ${github_uri} ..."
		git clone "$github_uri" "${dest_dir}" ||
		  fail "Failed to clone ${repo}!"
	fi
done

popd >/dev/null

log "Successfully setup a development environment in $dest_dir"
