#!/usr/bin/env bash

. ./test/helper.sh

./ronin-install.sh

function test_gcc_installed()
{
	assertTrue "did not successfully install gcc" '[ command -v gcc >/dev/null ]'
}

function test_make_installed()
{
	assertTrue "did not successfully install make" '[ command -v make >/dev/null ]'
}

function test_ruby_installed()
{
	assertTrue "did not successfully install ruby" '[ command -v ruby >/dev/null ]'
}

function test_ronin_install()
{
	assertTrue "did not successfully install ronin" '[ command -v ronin >/dev/null ]'
}

SHUNIT_PARENT=$0 . $SHUNIT2
