./ronin-install.sh

. ./test/helper.sh

function test_cmp_installed()
{
	assertCommandInstalled "did not successfully install cmp" 'cmp'
}

function test_cc_installed()
{
	assertCommandInstalled "did not successfully install cc" 'cc'
}

function test_make_installed()
{
	assertCommandInstalled "did not successfully install make" 'make'
}

function test_at_least_ruby_3_1_installed()
{
	# check if ruby >= 3.1 is already installed
	if [[ -n "$ruby_version" ]] &&
	   [[ "$ruby_version" != "2."* ]] &&
	   [[ "$ruby_version" != "3.0."* ]]; then
		return
	fi

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

	assertCommandInstalled "did not successfully install ruby" 'ruby'

	local ruby_version="$(ruby -e 'print RUBY_VERSION')"

	assertTrue "did not install ruby-3.x" \
		   '[[ "$ruby_version" == "3."* ]]'
}

function test_zip_install()
{
	assertCommandInstalled "did not successfully install zip" 'zip'
}

function test_git_install()
{
	assertCommandInstalled "did not successfully install git" 'git'
}

function test_nmap_install()
{
	assertCommandInstalled "did not successfully install nmap" 'nmap'
}

function test_masscan_install()
{
	assertCommandInstalled "did not successfully install masscan" 'masscan'
}

function test_graphviz_install()
{
	assertCommandInstalled "did not successfully install GraphViz" 'dot'
}

function test_ronin_install()
{
	assertCommandInstalled "did not successfully install ronin" 'ronin'
}

SHUNIT_PARENT=$0 . $SHUNIT2
