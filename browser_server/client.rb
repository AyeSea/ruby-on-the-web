require "socket"

hostname = "localhost"
port = 2000

#Creates a TCP/IP client socket connecting to the web server w/
#hostname at the specified port. Same open method that the File class
#uses, since TCPSocket inherits from IO.
s = TCPSocket.open(hostname, port)

#While there are still lines to read from the server socket
#(will evaluate to false once there are no more lines to read,
#because at that point s.gets will return nil).
while line = s.gets
	#Remove the last character from the line and print it to STDOUT.
	puts line.chop
end

#Close the client socket which closes the connection the localhost
#and its web server.
s.close