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

	private
	def receive_from_client
		@req = @client.gets.split(" ")
		@req_type = @req[0]
		@req_path = @req[1]
		puts @req.join(" ")

		@headers = []

		if @req_type == "GET"
			3.times { @headers << @client.gets }
			puts @headers
		else
			6.times { @headers << @client.gets }
			puts @headers
			@form_data = @client.gets
			puts @form_data
			params = JSON.parse(@form_data)
			@name = params["viking"]["name"]
			@email = params["viking"]["email"]
		end
	end

	def send_to_client
		@req_type == "GET" ? for_get : for_post
	end

	def for_get
		if @req_path == "/index.html"
			send_response_line
			file = "index.html"
			send_headers(file)
			send_body(file)
		else
			send_error_msg
		end
	end

	def for_post
		if @req_path == "/thanks.html"
			send_response_line
			file = "thanks.html"
			send_headers(file)
			send_body(file)
		else
			send_error_msg
		end
	end

	def send_response_line
		@client.puts "HTTP/1.0 200 OK"
	end

	def send_headers(file)
		@client.puts "Date: #{File.mtime(file)}"
		file == "index.html" ? file_type = "text/html" : file_type = "application/x-www-form-urlencoded"
		@client.puts "Content-Type: #{file_type}"
		@client.puts "Content-Length: #{File.size(file)}\r\n\r\n"
	end

	def send_body(file)
		file_contents = File.readlines(file)

		file_contents.each do |line|
			if line.include?("<%= yield %>")
				#substitute in post code
				@client.puts "\t\t\t<li>Name: #{@name}</li><li>Email: #{@email}</li>"
			else
				@client.puts line
			end
		end
	end

	def send_error_msg
		@client.puts "HTTP/1.0 404 File Not Found"
		@client.puts "Sorry, it looks like '#{@req_path}' does not exist."
	end
end

cli_server = Server.new
cli_server.run