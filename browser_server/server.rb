require 'socket'
require 'json'

class Server
	def initialize(port = 2000)
		@server = TCPServer.open(port)
	end

	def run
		loop {
			@client = @server.accept
			receive_from_client
			send_to_client
			@client.puts "Closing the connection. Bye!"
			@client.close
		}
	end

	def receive_from_client
		#update line below so that the connection doesn't close....
		#the read method closes the connection once all contents are read in
		@req = @client.gets.split(" ")
		@req_type = @req[0]
		@req_path = @req[1]
		puts @req.join(" ")

		@headers = [] 
		3.times { @headers << @client.gets }
		puts @headers
	end

	def send_to_client
		@req_type == "GET" ? for_get : for_post
	end

	def for_get
		if @req_path == "/index.html"
			send_response_line
			file = "index.html"
			send_headers(file)
			
			page_contents = File.readlines(file)

			page_contents.each do |line|
				@client.puts line
			end
		else
			send_error_msg
		end
	end

	def for_post
		if @req_path == "/thanks.html"
			send_response_line
			file = "thanks.html"
			send_headers(file)
			###
			###CODE FOR SENDING THANKS.HTML BODY OVER HERE!!!
			###
		else
			send_error_msg
		end
	end

	def send_response_line
		@client.puts "HTTP/1.0 200 OK"
	end

	def send_headers(file)
		@client.puts "Date: #{File.mtime(file)}"
		@client.puts "Content-Type: #{File.extname(file)}"
		@client.puts "Content-Length: #{File.size(file)}\r\n\r\n"
	end

	def send_error_msg
		@client.puts "HTTP/1.0 404 File Not Found for #{@req_path}"
	end
end

cli_server = Server.new
cli_server.run