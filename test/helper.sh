[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

function oneTimeSetUp() { return; }
function setUp() { return; }
function tearDown() { return; }
function oneTimeTearDown() { return; }

function assertCommandInstalled()
{
	assertTrue "$1" "command -v \"$2\" >/dev/null"
}

function assertDirectory()
{
	assertTrue "$1" "[[ -d \"$2\" ]]"
}

function assertGitRepo()
{
	assertDirectory "$1" "$2/.git"
}
