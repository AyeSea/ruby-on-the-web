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
		send_req
		receive_resp
	end

	private
	def create_http_req
		@req_type = confirm_req_type
		@req_path = confirm_req_path
		@content_type = @req_type == "GET" ? "text/html" : "application/x-www-form-urlencoded"
		@req = "#{@req_type} #{@req_path} HTTP/1.0\r\n\r\n"
	end

	def send_req
		@socket.print @req
		headers
	end

	def receive_resp
		resp = @socket.read
		headers, body = resp.split("\r\n\r\n")
		puts headers
		puts body
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
		@socket.puts "User-Agent: CLI Browser v1.0\r\n\r\n"
	end

end

cli_browser = Browser.new
cli_browser.run