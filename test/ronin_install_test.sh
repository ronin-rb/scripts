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
	if [[ "$(uname -s)" == "Darwin" ]]; then
		local ruby_path="$(brew --prefix ruby)/bin/ruby"

		assertTrue "did not install ruby via homebrew" \
			   '[[ -x "$ruby_path" ]]'

		local ruby_version="$("$ruby_path" -e 'print RUBY_VERSION')"

		assertTrue "did not install ruby-3.x" \
			   '[[ "$ruby_version" == "3."* ]]'
	else
		assertCommandInstalled "did not successfully install ruby" 'ruby'

		local ruby_version="$(ruby -e 'print RUBY_VERSION')"

		assertTrue "did not install ruby-3.x" \
			   '[[ "$ruby_version" == "3."* ]]'
	fi
}

function test_ronin_install()
{
	if [[ "$(uname -s)" == "Darwin" ]]; then
		local zshrc="$(cat ~/.zshrc)"

		assertContains 'did not add PATH="$(brew --prefix ruby)/bin:$PATH to ~/.zshrc' \
			       "$zshrc" 'PATH="$(brew --prefix ruby)/bin:$PATH'

		assertContains 'did not add PATH="$(gem env gemdir)/bin:$PATH" to ~/.zshrc' \
			       "$zshrc" 'PATH="$(gem env gemdir)/bin:$PATH"'

		PATH="$(brew --prefix ruby)/bin:$PATH"
		PATH="$(gem env gemdir)/bin:$PATH"
		hash -r
	fi

	assertCommandInstalled "did not successfully install ronin" 'ronin'
}

SHUNIT_PARENT=$0 . $SHUNIT2
