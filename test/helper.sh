[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

test_ruby_version=$(ruby -e 'print RUBY_VERSION')

function oneTimeSetUp() { return; }
function setUp() { return; }
function tearDown() { return; }
function oneTimeTearDown() { return; }

function assertCommandInstalled()
{
	assertTrue "$1" "command -v \"$2\" >/dev/null"
}

function assertFile()
{
	assertTrue "$1" "[[ -f \"$2\" ]]"
}

function assertDirectory()
{
	assertTrue "$1" "[[ -d \"$2\" ]]"
}

function assertGitRepo()
{
	assertDirectory "$1" "$2/.git"
}
