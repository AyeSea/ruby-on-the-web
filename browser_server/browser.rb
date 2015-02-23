require 'socket'
require 'json'

class Browser
	def initialize(host = "localhost", port = 2000)
		@host = host
		@port = port
		@socket = TCPSocket.open(host, port)
	end

	def run
		create_http_req
		create_viking if @req_type == "POST"
		send_req
		receive_resp
	end

	private
	def create_http_req
		@req_type = confirm_req_type
		@req_path = confirm_req_path
		@req = "#{@req_type} #{@req_path} HTTP/1.0\r\n\r\n"
	end

	def send_req
		@socket.print @req
		headers
	end

	def receive_resp
		resp = @socket.read
		resp_headers, resp_body = resp.split("\r\n\r\n")
		puts resp_headers
		puts resp_body
	end

	def confirm_req_type
		loop do
			puts "Do you want to send your request as (GET) or (POST)?"
			reply = gets.chomp.upcase
			return reply if reply == "GET" || reply == "POST"
			puts "#{reply} is not a valid response. Please try again."
		end
	end

	def confirm_req_path
		puts "Please enter the path of the file you want from #{@host}:"
		reply = gets.chomp
	end

	def headers
		@socket.puts "From: testuser@theodinproject.com"
		@socket.puts "User-Agent: CLI Browser v1.0"
		if @req_type == "POST"
			@socket.puts "Content-Type: application/x-www-form-urlencoded"
			@socket.puts "Content-Length: #{@form_data.size}\r\n\r\n"
			@socket.puts @form_data
		end
	end

	def create_viking
		@form_data = {}
		puts "You've chosen to register a viking for a raid!"
		puts "Enter your name:"
		@name = gets.chomp.capitalize
		puts "Enter your email:"
		@email = gets.chomp

		@form_data[:viking] = {:name=>@name, :email=>@email}
		@form_data = @form_data.to_json
	end

end

cli_browser = Browser.new
cli_browser.run