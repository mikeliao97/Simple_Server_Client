require 'socket'
require 'json'

server = TCPServer.open(2000)


loop {
  	
	#shameless stole syntax from qdevdive
	socket = server.accept
  	request = ""
	while line = socket.gets
		request << line
		break if request =~ /\r\n\r\n$/
	end

	body_size = request.split("\r\n")[-1].split(" ")[-1].to_i
	puts body_size

		# and read exactly that many bytes out of the socket
	body = socket.read(body_size) 

	puts request
	puts body_size
	puts body
	 
	
	  #if the response includes GET as part of its first line?
  if(request.include?("GET /index.html"))


	f = File.open("index.html", "r")
    
    	f.each_line do |line|
      		response += line + "\n"
    	end

    #now send a properly formatted HTTP Response
    socket.print("HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n")                        

  elsif(request.include?("POST"))
	#if the post request includes thanks.html then append and puts the file of thanks with the json hash
	params = Hash.new
	params = JSON.parse(body)

	#need to find a way to get the line after content-length
	response = ""	
	
	f = File.open("thanks.html", "r")
    
    	f.each_line do |line|
      		
		
		#so if the line includes yield, then just add the json objects to the response
		if(line.include?("yield"))
			params.each do |key, values|
				values.each do |k, v|
					response << "<li> #{k}: #{v} </li> \r\n"
				end	

			end					
		else
			response << line 
		end
    	end


  #can't find the file
  else
       socket.print("HTTP/1.1 404 Error! \r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{request.bytesize}\r\n" +
               "Connection: close\r\n")                        

      response += " + \n"
  end 

  #print a blank line to separate the header from the response body 
  socket.print "\r\n"

  #Now print the actual response boyd, which is Hello World
  socket.print(response) 

  socket.close
  
}





