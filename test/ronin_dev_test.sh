#!/usr/bin/env bash

./ronin-dev.sh

. ./test/helper.sh

function test_cmp_installed()
{
	assertCommandInstalled "did not successfully install cmp" 'cmp'
}

function test_git_installed()
{
	assertCommandInstalled "did not successfully install git" 'git'
}

function test_cc_installed()
{
	assertCommandInstalled "did not successfully install cc" 'cc'
}

function test_make_installed()
{
	assertCommandInstalled "did not successfully install make" 'make'
}

function test_awk_installed()
{
	assertCommandInstalled "did not successfully install awk" 'awk'
}

function test_ruby_3_x_installed()
{
	# check if ruby-3.x is already installed
	if [[ "$test_ruby_version" == "3."* ]]; then
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

function test_bundle_installed()
{
	assertCommandInstalled "did not successfully install bundler" 'bundle'
}

function test_zip_install()
{
	assertCommandInstalled "did not successfully install zip" 'zip'
}

function test_src_dir()
{
	assertDirectory "did not successfully create the ~/src directory" "$HOME/src"
}

function_test_ronin_rb_dir()
{
	assertDirectory "did not successfully create the ~/src/ronin-rb directory" "$HOME/src/ronin-rb"
}

function test_docker_repo()
{
	assertGitRepo "did not successfully git clone the docker repo" "$HOME/src/ronin-rb/docker"
}

function test_ronin_repo()
{
	assertGitRepo "did not successfully git clone the ronin repo" "$HOME/src/ronin-rb/ronin"
}

function test_ronin_agent_node_repo()
{
	assertGitRepo "did not successfully git clone the ronin-agent-node repo" "$HOME/src/ronin-rb/ronin-agent-node"
}

function test_ronin_agent_php_repo()
{
	assertGitRepo "did not successfully git clone the ronin-agent-php repo" "$HOME/src/ronin-rb/ronin-agent-php"
}

function test_ronin_agent_ruby_repo()
{
	assertGitRepo "did not successfully git clone the ronin-agent-ruby repo" "$HOME/src/ronin-rb/ronin-agent-ruby"
}

function test_ronin_brute_repo()
{
	assertGitRepo "did not successfully git clone the ronin-brute repo" "$HOME/src/ronin-rb/ronin-brute"
}

function test_ronin_asm_repo()
{
	assertGitRepo "did not successfully git clone the ronin-asm repo" "$HOME/src/ronin-rb/ronin-asm"
}

function test_ronin_core_repo()
{
	assertGitRepo "did not successfully git clone the ronin-core repo" "$HOME/src/ronin-rb/ronin-core"
}

function test_ronin_db_repo()
{
	assertGitRepo "did not successfully git clone the ronin-db repo" "$HOME/src/ronin-rb/ronin-db"
}

function test_ronin_db_activerecord_repo()
{
	assertGitRepo "did not successfully git clone the ronin-db-activerecord repo" "$HOME/src/ronin-rb/ronin-db-activerecord"
}

function test_ronin_dns_proxy_repo()
{
	assertGitRepo "did not successfully git clone the ronin-dns-proxy repo" "$HOME/src/ronin-rb/ronin-dns-proxy"
}

function test_ronin_listener_repo()
{
	assertGitRepo "did not successfully git clone the ronin-listener repo" "$HOME/src/ronin-rb/ronin-listener"
}

function test_ronin_listener_dns_repo()
{
	assertGitRepo "did not successfully git clone the ronin-listener-dns repo" "$HOME/src/ronin-rb/ronin-listener-dns"
}

function test_ronin_listener_http_repo()
{
	assertGitRepo "did not successfully git clone the ronin-listener-http repo" "$HOME/src/ronin-rb/ronin-listener-http"
}

function test_ronin_exploits_repo()
{
	assertGitRepo "did not successfully git clone the ronin-exploits repo" "$HOME/src/ronin-rb/ronin-exploits"
}

function test_ronin_fuzzer_repo()
{
	assertGitRepo "did not successfully git clone the ronin-fuzzer repo" "$HOME/src/ronin-rb/ronin-fuzzer"
}

function test_ronin_masscan_repo()
{
	assertGitRepo "did not successfully git clone the ronin-masscan repo" "$HOME/src/ronin-rb/ronin-masscan"
}

function test_ronin_nmap_repo()
{
	assertGitRepo "did not successfully git clone the ronin-nmap repo" "$HOME/src/ronin-rb/ronin-nmap"
}

function test_ronin_payloads_repo()
{
	assertGitRepo "did not successfully git clone the ronin-payloads repo" "$HOME/src/ronin-rb/ronin-payloads"
}

function test_ronin_post_ex_repo()
{
	assertGitRepo "did not successfully git clone the ronin-post_ex repo" "$HOME/src/ronin-rb/ronin-post_ex"
}

function test_ronin_rb_github_io_repo()
{
	assertGitRepo "did not successfully git clone the ronin-rb.github.io repo" "$HOME/src/ronin-rb/ronin-rb.github.io"
}

function test_ronin_website_symlink()
{
	assertTrue "did not successfully create the website -> ronin-rb.github.io symlink" '[[ -L "$HOME/src/ronin-rb/website" ]] && [[ -e "$HOME/src/ronin-rb/website" ]]'
}

function test_ronin_recon_repo()
{
	assertGitRepo "did not successfully git clone the ronin-recon repo" "$HOME/src/ronin-rb/ronin-recon"
}

function test_ronin_repos_repo()
{
	assertGitRepo "did not successfully git clone the ronin-repos repo" "$HOME/src/ronin-rb/ronin-repos"
}

function test_ronin_sql_repo()
{
	assertGitRepo "did not successfully git clone the ronin-code-sql repo" "$HOME/src/ronin-rb/ronin-code-sql"
}

function test_ronin_support_repo()
{
	assertGitRepo "did not successfully git clone the ronin-support repo" "$HOME/src/ronin-rb/ronin-support"
}

function test_ronin_vulns_repo()
{
	assertGitRepo "did not successfully git clone the ronin-vulns repo" "$HOME/src/ronin-rb/ronin-vulns"
}

function test_ronin_web_repo()
{
	assertGitRepo "did not successfully git clone the ronin-web repo" "$HOME/src/ronin-rb/ronin-web"
}

function test_ronin_web_server_repo()
{
	assertGitRepo "did not successfully git clone the ronin-web-server repo" "$HOME/src/ronin-rb/ronin-web-server"
}

function test_ronin_web_session_cookie_repo()
{
	assertGitRepo "did not successfully git clone the ronin-web-session_cookie repo" "$HOME/src/ronin-rb/ronin-web-session_cookie"
}

function test_ronin_web_spider_repo()
{
	assertGitRepo "did not successfully git clone the ronin-web-spider repo" "$HOME/src/ronin-rb/ronin-web-spider"
}

function test_ronin_web_user_agents_repo()
{
	assertGitRepo "did not successfully git clone the ronin-web-user_agents repo" "$HOME/src/ronin-rb/ronin-web-user_agents"
}

function test_rubocop_ronin_repo()
{
	assertGitRepo "did not successfully git clone the rubocop-ronin repo" "$HOME/src/ronin-rb/rubocop-ronin"
}

function test_scripts_repo()
{
	assertGitRepo "did not successfully git clone the scripts repo" "$HOME/src/ronin-rb/scripts"
}

function test_bundle_install()
{
	local ret

	cd "$HOME/src/ronin-rb/ronin"
	bundle install
	ret=$?

	assertEquals "did not successfully run bundle install" $ret 0
}

SHUNIT_PARENT=$0 . $SHUNIT2
