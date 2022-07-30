#!/usr/bin/env bash

. ./test/helper.sh

function test_ronin_install()
{
	./ronin-install.sh

	assertTrue "did not successfully install ronin" '[ command -v ronin >/dev/null ]'
}

SHUNIT_PARENT=$0 . $SHUNIT2
