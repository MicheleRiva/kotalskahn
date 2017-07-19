require 'socket'

# Create a new log file
LOG_FILE = File.new("log.txt", "w")

# Get remote address as ARGV.
# If no remote address is supplied, we'll check localhost.
REMOTE_ADDR = ARGV[0] || 'localhost'

# Set timeout in seconds
TIMEOUT =  10

# Let's define the Skahn method
def skahn(port)

  socket      = Socket.new(:INET, :STREAM)
  addr        = Socket.sockaddr_in(port, REMOTE_ADDR)

  begin
    socket.connect_nonblock(addr)
    rescue Errno::EINPROGRESS
  end

  _, sockets, _ = IO.select(nil, [socket], nil, TIMEOUT)

  if sockets

    logtext = "[OPEN PORT] - #{port} \n"
    print logtext
    File.write(LOG_FILE, logtext, mode: 'a')

  end

end

# Configure port list
PORT_LIST = [20,21,22,23,25,53,80,110,143,443,465,587,1433,3000,3128,3306,5432,8000,8080]
threads   = []

# Loop function
PORT_LIST.each do |port|
  threads << Thread.new { skahn(port) }
end

# Let's start

require './utils/head.rb'

threads.each(&:join)