require "socket"

#Create a TCP/IP server socket to listen on port 2000.
#Inherits from class IO, so same IO#open method that we use w/ the File class.
server = TCPServer.open(2000)
#Servers run forever so loop all actions.
loop {
	#Waits for a connection from a client, then returns the TCPSocket object
	#representing that connection (so client here is the client socket
	#while server is the server socket).
	client = server.accept
	#Send time to the client
	client.puts(Time.now.ctime)
	#Sends display of string to the client
	client.puts "Closing the connection. Bye!"
	#Disconnects from the client socket and closes the connection.
	client.close
}