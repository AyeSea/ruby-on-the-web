require "socket"

#Web server hostname
host = "localhost"
port = 2000
#local path/URL
path = "/index.html"

#HTTP request we send to GET a file
request = "GET #{path} HTTP/1.0\r\n\r\n"

#Open a TCP/IP client socket to the specified host at the specified port.
#Establishes connection to the TCP/IP client server socket at host & port.
socket = TCPSocket.open(host, port)
#Send our HTTP GET request over the connection to the web server
socket.print(request)
#Read the response from the web server. Socket communication is bi-directional,
#so we send requests and receive responses on the same socket.
response = socket.read
#Split response at first blank line into headers and body, where
#everything after the first blank line is considered the body.
headers, body = response.split("\r\n\r\n", 2)
puts headers
puts body