require 'socket'
require 'json'

def request_type
	loop do
		puts "Please enter what type of request you want to send:"
		puts "(options are GET and POST)"
		reply = gets.chomp.upcase
		return reply if ["GET", "POST"].include?(reply)
	end

end

def post_details
	form_data = {}
	form_data["viking"] = nil
	puts "Please enter your viking's name:"
	name = gets.chomp.upcase
	puts "Please enter your email:"
	email = gets.chomp
	form_data[:viking] = {:name=>name, :email=>email}
	form_data = form_data.to_json
end

host = "localhost"
port = 2000
req_type = request_type
path = req_type == "GET" ? "/index.html" : "/thanks.html"
content_type = path == "/index.html" ? "text/html" : "application/x-www-form-urlencoded"
post_data = post_details if req_type == "POST"
request = "#{req_type} #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(host, port)
socket.puts(request)
socket.puts "From: user@theodinproject.com"
socket.puts "User-Agent: CLI Browser 1.0"
socket.puts "Content-Type: #{content_type}"

if post_data
	socket.puts "Content-Length: #{post_data.length}"
	socket.puts post_data
end

response = socket.read
headers, body = response.split("\r\n\r\n", 2)
puts headers
puts body