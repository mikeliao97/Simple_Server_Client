require 'socket'
require 'json'



host = 'localhost'
port = 2000
path = "/index.html"   #The file we want
header = ""
browserInfo = "From: mikeliao97@berkeley.edu\r\n" +
	      "User-Agent: HTTPTool/1.0\r\n" +
additionalRequest = ""

#Promp the user
puts "Would you like to send a POST or GET request?"

typeOfResponse = gets.chomp

if typeOfResponse == "POST"
	puts "Your name?" 
	name = gets.chomp

	puts "Your email?"
        email = gets.chomp

 	puts "Your name is #{name} and your email is #{email}"

        hash = {:viking => {:name=> "#{name}", :email=> "#{email}"}}

	#set the addition request to the has and its json form
	additionalRequest = hash.to_json
	
	#add the Content Lenght line
	browserInfo << "Content-Length: #{additionalRequest.bytesize}\r\n\r\n"

	#set the path
	path = "/thanks.html"
	header = "POST #{path} HTTP/1.0\r\n"
	
elsif typeOfResponse == "GET"
	
	#set the path to index.html to read index.html
	path = "/index.html"
	header = "GET #{path} HTTP/1.0\r\n"

else
	puts "Sorry no command recognized! Quitting!"
end
	#Open the 
	socket = TCPSocket.open(host, port)
	
	#The request
	request = header + browserInfo + additionalRequest	
	puts "this is the request:"
	puts request
	
	#give the reqeust to the server
	socket.print(request)
	
	#read the response and print it
	response = socket.read
	puts response


#Split response at first blank line into headers and body
#headers, body = response.split("\r\n\r\n", 2)
#print body
#print headers
