[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

function oneTimeSetUp() { return; }
function setUp() { return; }
function tearDown() { return; }
function oneTimeTearDown() { return; }
