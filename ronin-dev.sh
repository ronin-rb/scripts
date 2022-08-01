#!/usr/bin/env bash

bundler_version="~> 2.0"

github_org="ronin-rb"
github_base_uri="https://github.com/$github_org"
github_repos=(
	docker
	ronin
	ronin-agent-node
	ronin-agent-php
	ronin-agent-ruby
	ronin-asm
	ronin-core
	ronin-db
	ronin-db-activerecord
	ronin-exploits
	ronin-fuzzer
	ronin-payloads
	ronin-post_ex
	ronin-rb.github.io
	ronin-repos
	ronin-sql
	ronin-support
	ronin-vuln-lfi
	ronin-vuln-rfi
	ronin-web
	ronin-web-server
	ronin-web-spider
	ronin-web-user_agents
	scripts
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

function detect_system()
{
	detect_os
	detect_sudo
	detect_package_manager
}

function detect_rubygems_install_dir()
{
	local gem_home="$(gem env GEM_HOME)"

	if [[ -d "$gem_home" ]] && [[ ! -w "$gem_home" ]]; then
		gem="sudo gem"
	else
		gem="gem"
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

function auto_install_make()
{
	if ! command -v make >/dev/null; then
		log "Install make ..."
		install_packages make || fail "Failed to install make!"
	fi
}

#
# Installs bundler, if it's not installed.
#
function auto_install_bundler()
{
	if ! command -v bundle >/dev/null; then
		log "Installing bundler ..."
		$gem install --no-format-executable bundler -v "$bundler_version" ||
			fail "Failed to install bundler!"
	elif [[ "$(bundle --version)" == "Bundler version 1."* ]]; then
		log "Updating bundler 1.x to 2.x ..."
		$gem update --no-format-executable bundler
	fi
}

function install_dependencies()
{
	case "$package_manager" in
		dnf|yum)libraries=(readlin-devel sqlite-devel libxml2-devel libxslt-devel) ;;
		zypper)	libraries=(readline-devel sqlite3-devel libxml2-devel libxslt-devel) ;;
		apt)	libraries=(libreadline-dev libsqlite3-dev libxml2-dev libxslt1-dev) ;;
		*)	libraries=(readline sqlite libxml2 libxslt) ;;
	esac

	log "Installing external dependencies ..."
	install_packages "${libraries[@]}" || \
	  warn "Failed to install external dependencies. Proceeding anyways."
}

detect_system
echo "package_manager=$package_manager"
auto_install_git
auto_install_gcc
auto_install_make
auto_install_ruby
auto_install_bundler
install_dependencies

mkdir -p "$ronin_src_dir"
pushd "$ronin_src_dir"/ >/dev/null

for repo in "${github_repos[@]}"; do
	github_uri="${github_base_uri}/${repo}.git"

	if [[ -d  "$repo" ]]; then
		warn "Clone ${dest_dir} already exists. Skipping."
	else
		log "Cloning ${github_uri} ..."
		git clone "$github_uri" "$repo" || \
		  fail "Failed to clone $repo!"

		pushd "$repo" >/dev/null

		if [[ -f Gemfile ]]; then
			# Have bundler install all gems into a shared gem dir
			bundle config set --local path ../vendor/bundle >/dev/null || fail "Failed to run 'bundle config'"
		fi

		popd >/dev/null
	fi
done

ln -sf ronin-rb.github.io website
popd >/dev/null

log "Successfully setup a development environment in ${ronin_src_dir}"
