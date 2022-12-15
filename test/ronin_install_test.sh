#!/usr/bin/env bash

. ./test/helper.sh

./ronin-install.sh

function test_gcc_installed()
{
	assertCommandInstalled "did not successfully install gcc" 'gcc'
}

function test_make_installed()
{
	assertCommandInstalled "did not successfully install make" 'make'
}

function test_ruby_3_x_installed()
{
	assertCommandInstalled "did not successfully install ruby" 'ruby'

	local ruby_version="$(ruby -e 'print RUBY_VERSION')"

	assertTrue "did not install ruby-3.x" '[[ "$ruby_version" == "3."* ]]'
}

function test_ronin_install()
{
	assertCommandInstalled "did not successfully install ronin" 'ronin'
}

SHUNIT_PARENT=$0 . $SHUNIT2
