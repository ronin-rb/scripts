#!/usr/bin/env bash

gem="gem"
gem_opts=(--no-format-executable)

bundler_version="~> 2.0"

github_org="ronin-rb"
github_base_uri="https://github.com/$github_org"
github_repos=(
	docker
	ronin
	ronin-agent-node
	ronin-agent-php
	ronin-agent-ruby
	ronin-brute
	ronin-code-asm
	ronin-code-sql
	ronin-core
	ronin-db
	ronin-db-activerecord
	ronin-dns-proxy
	ronin-listener
	ronin-listener-dns
	ronin-listener-http
	ronin-exploits
	ronin-fuzzer
	ronin-masscan
	ronin-nmap
	ronin-payloads
	ronin-post_ex
	ronin-rb.github.io
	ronin-recon
	ronin-repos
	ronin-support
	ronin-vulns
	ronin-web
	ronin-web-server
	ronin-web-session_cookie
	ronin-web-spider
	ronin-web-user_agents
	rubocop-ronin
	scripts
)

src_dir="$HOME/src"
ronin_src_dir="${src_dir}/${github_org}"

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
			elif [[ "$HOME" == *"com.termux"* ]]; then
				package_manager="termux"
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

#
# Detect the ruby version.
#
function detect_ruby_version()
{
	if command -v ruby >/dev/null; then
		ruby_version="$(ruby -e 'print RUBY_VERSION')"
	fi
}

#
# Detect the system.
#
function detect_system()
{
	check_lang
	detect_os
	detect_sudo
	detect_package_manager
	detect_ruby_version
}

#
# Detect where rubygems installs gems into and whether it's writable.
#
function detect_rubygems_install_dir()
{
	local gem_dir="$(gem env gemdir)"

	if (( UID == 0 )); then
		gem_opts+=(--no-user-install)
	elif [[ -d "$gem_dir" ]] && [[ ! -w "$gem_dir" ]]; then
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
		termux)	pkg install -y "$@" || return $? ;;
		"")	warn "Could not determine Package Manager. Proceeding anyway." ;;
	esac
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
			*)		install_packages ruby ;;
		esac || fail "Failed to install ruby!"
	fi

	auto_install_rubygems
}

#
# Install rubygems if it's missing.
#
function auto_install_rubygems()
{
	if ! command -v gem >/dev/null; then
		log "Installing rubygems ..."
		case "$package_manager" in
			dnf|yum|pacman)	install_packages rubygems ;;
			pkg)		install_packages devel/ruby-gems ;;
			*)
				fail "rubygems was not installed along with ruby. Aborting!"
				;;
		esac
	fi

	detect_rubygems_install_dir
}

#
# Install gcc if there's no C compiler on the system.
#
function auto_install_cc()
{
	if ! command -v cc >/dev/null; then
		case "$package_manager" in
			termux)
				log "Installing clang ..."
				install_packages clang || \
				  fail "Failed to install clang!"
				;;
			*)
				log "Installing gcc ..."
				install_packages gcc || \
				  fail "Failed to install gcc!"
				;;
		esac
	fi
}

#
# Install g++ if there's no C++ compiler on the system.
#
function auto_install_cpp()
{
	if ! command -v c++ >/dev/null; then
		case "$package_manager" in
			dnf|yum)
				log "Installing g++ ..."
				install_packages gcc-g++ || \
				  fail "Failed to install g++!"
				;;
			zypper)
				log "Installing g++ ..."
				install_packages gcc-c++ || \
				  fail "Failed to install g++!"
				;;
			termux)
				log "Installing clang ..."
				install_packages clang || \
				  fail "Failed to install clang!"
				;;
			*)
				log "Installing g++ ..."
				install_packages g++ || \
				  fail "Failed to install g++!"
				;;
		esac
	fi
}

#
# Install make if it's not already installed.
#
function auto_install_make()
{
	if ! command -v make >/dev/null; then
		log "Installing make ..."
		install_packages make || fail "Failed to install make!"
	fi
}

#
# Install pkg-config if it's not already installed.
#
function auto_install_pkg_config()
{
	if ! command -v pkg-config >/dev/null; then
		# NOTE: BSDs needs pkg-config to compile the sqlite3 gem
		case "$package_manager" in
			pkg)
				log "Installing pkg-config ..."
				install_packages devel/pkgconf
				;;
		esac || fail "Failed to install pkg-config!"
	fi
}

#
# Installs bundler, if it's not installed.
#
function auto_install_bundler()
{
	if ! command -v bundle >/dev/null; then
		log "Installing bundler ..."
		$gem install ${gem_opts[@]} bundler -v "$bundler_version" ||
			fail "Failed to install bundler!"
	elif [[ "$(bundle --version)" == "Bundler version 1."* ]]; then
		log "Updating bundler 1.x to 2.x ..."
		$gem update ${gem_opts[@]} bundler
	fi
}

#
# Explicitly install nokogiri on Termux by building it against the system's
# libxml2 and libxslt packages.
#
function termux_install_nokogiri()
{
	# XXX: compile nokogiri against the system's libxml2 library,
	# to workaround issue with the libxml2 tar archive containing
	# hardlinks.
	$gem install nokogiri --platform ruby -- --use-system-libraries || \
	  warn "Failed to compile nokogiri. Proceeding anyways."
}

#
# Install external dependencies for ronin.
#
function install_dependencies()
{
	case "$package_manager" in
		dnf|yum)libraries=(libyaml-devel zip) ;;
		zypper)	libraries=(awk libyaml-devel zip) ;;
		apt)	libraries=(libyaml-dev zip) ;;
		termux) libraries=(binutils libyaml libxml2 libxslt zip) ;;
		*)	libraries=(libyaml zip) ;;
	esac

	log "Installing external dependencies ..."
	install_packages "${libraries[@]}" || \
	  warn "Failed to install external dependencies. Proceeding anyways."

	if [[ "$package_manager" == "termux" ]] && \
	   [[ -z "$(gem which nokogiri 2>/dev/null)" ]]; then
		termux_install_nokogiri
	fi
}

#
# Print the --help usage.
#
function print_usage()
{
	cat <<USAGE
usage: ./ronin-dev.sh [OPTIONS] [REPO ...]

Options:
	    --package-manager [apt|dnf|yum|pacman|zypper|brew|pkg|port]
	    			Sets the package manager to use
	-V, --version		Prints the version
	-h, --help		Prints this message

USAGE
}

#
# Parse additional command-line options.
#
function parse_options()
{
	local argv=()

	while [[ $# -gt 0 ]]; do
		case "$1" in
			--package-manager)
				package_manager="$2"
				shift 2
				;;
			-V|--version)
				echo "ronin-dev: $ronin_install_version"
				exit
				;;
			-h|--help)
				print_usage
				exit
				;;
			-*)
				echo "ronin-dev: unrecognized option $1" >&2
				return 1
				;;
			*)
				argv+=($1)
				shift
				;;
		esac
	done

	if (( ${#argv[@]} > 0 )); then
		github_repos=("${argv[@]}")
	fi
}

parse_options "$@" || exit $?
detect_system
auto_install_git
auto_install_cc
auto_install_cpp
auto_install_make
auto_install_pkg_config
auto_install_ruby
auto_install_bundler
install_dependencies

mkdir -p "$ronin_src_dir"
pushd "$ronin_src_dir"/ >/dev/null

for repo in "${github_repos[@]}"; do
	github_uri="${github_base_uri}/${repo}.git"

	if [[ -d  "$repo" ]]; then
		warn "Repository '${repo}' already exists. Skipping."
	else
		log "Cloning ${github_uri} ..."
		git clone "$github_uri" "$repo" || \
		  fail "Failed to clone '$repo!'"

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

echo
for dir in "${ronin_src_dir}"/*; do
	echo "	~/${dir#$HOME/}"
done
echo

if [[ ! "$ruby_version" == "3."* ]] && [[ "$package_manager" == "brew" ]]; then
	warn "Ruby ${ruby_version} was installed via Homebrew."
	warn "You will need to restart your shell or open a new terminal."
fi
