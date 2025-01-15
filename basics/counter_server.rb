require "socket"

server = TCPServer.new("localhost", 3003)

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split
  path, params = path_and_params.split("?")
  unless params.nil?
    params = params.split("&")
    params = params.map { |param| param.split("=") }
    params = params.each_with_object({}) do |param, hsh|
      hsh[param[0]] = param[1]
    end
  else
    params = {}
  end

  [http_method, path, params]
end

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"
  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<p><a href='?number=#{number + 1}'>Add to the number!<a/></p>"
  client.puts
  client.puts "<p><a href='?number=#{number - 1}'>Subtract from the number!</a></p>"

  client.puts "</body>"
  client.puts "</html>"
  client.close
end