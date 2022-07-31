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

function test_ruby_installed()
{
	assertCommandInstalled "did not successfully install ruby" 'ruby'
}

function test_ronin_install()
{
	assertCommandInstalled "did not successfully install ronin" 'ronin'
}

SHUNIT_PARENT=$0 . $SHUNIT2
