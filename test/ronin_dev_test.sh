#!/usr/bin/env bash

. ./test/helper.sh

./ronin-dev.sh

function test_git_installed()
{
	assertCommandInstalled "did not successfully install git" 'git'
}

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

function test_bundle_installed()
{
	assertCommandInstalled "did not successfully install bundler" 'bundle'
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

function test_ronin_asm_repo()
{
	assertGitRepo "did not successfully git clone the ronin-code-asm repo" "$HOME/src/ronin-rb/ronin-code-asm"
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

function test_ronin_exploits_repo()
{
	assertGitRepo "did not successfully git clone the ronin-exploits repo" "$HOME/src/ronin-rb/ronin-exploits"
}

function test_ronin_fuzzer_repo()
{
	assertGitRepo "did not successfully git clone the ronin-fuzzer repo" "$HOME/src/ronin-rb/ronin-fuzzer"
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

function test_ronin_vuln_repo()
{
	assertGitRepo "did not successfully git clone the ronin-vuln repo" "$HOME/src/ronin-rb/ronin-vuln"
}

function test_ronin_web_repo()
{
	assertGitRepo "did not successfully git clone the ronin-web repo" "$HOME/src/ronin-rb/ronin-web"
}

function test_ronin_web_server_repo()
{
	assertGitRepo "did not successfully git clone the ronin-web-server repo" "$HOME/src/ronin-rb/ronin-web-server"
}

function test_ronin_web_spider_repo()
{
	assertGitRepo "did not successfully git clone the ronin-web-spider repo" "$HOME/src/ronin-rb/ronin-web-spider"
}

function test_ronin_web_user_agents_repo()
{
	assertGitRepo "did not successfully git clone the ronin-web-user_agents repo" "$HOME/src/ronin-rb/ronin-web-user_agents"
}

function test_scripts_repo()
{
	assertGitRepo "did not successfully git clone the scripts repo" "$HOME/src/ronin-rb/scripts"
}

SHUNIT_PARENT=$0 . $SHUNIT2
