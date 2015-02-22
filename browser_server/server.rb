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
	req = client.gets.split(" ")
	method = req[0]
	path = req[1]
	http_version = req[2].chomp
	file = "index.html"

	#If request method is GET and the path is "index.html", then
	if method == "GET" && path == "/index.html"
		#send properly formatted HTTP response to client and
		client.puts "#{http_version} 200 OK"
		client.puts "Date: #{File.mtime(file)}"
		client.puts "Content-Type: #{File.extname(file)}"
		client.puts "Content-Length: #{File.size(file)}"
		puts "\r\n\r\n"
		#open index.html and send its contents over to the client.
		page_contents = File.readlines(file)

		page_contents.each do |line|
			client.puts line
		end
	else
		client.puts "#{http_version} 404 Not Found"
	end

	#Send time to the client
	client.puts(Time.now.ctime)
	#Sends display of string to the client
	client.puts "Closing the connection. Bye!"
	#Disconnects from the client socket and closes the connection.
	client.close
}