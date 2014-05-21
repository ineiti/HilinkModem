require 'net/http'
require "active_support/core_ext"
require 'active_support'
require 'serialport'

module Hilink
  class << self
    def send_request( path, request = {} )
      url = "/api/#{path}"
      http = Net::HTTP.new("192.168.1.1")
      
      if request != {} 
        req = Net::HTTP::Post.new(url)
        req.body = request.to_xml(root: "request", indent: 0, skip_types: true) 
        req.content_type = 'text/xml'
      else
        req = Net::HTTP::Get.new(url)
      end

      puts "Calling #{url} with _#{req.body}_"
      response = http.request(req).body

      Hash.from_xml( response )['response']
    end

    def switch_to_modem
      send_request( "device/mode", :mode => 0 )
    end

    def switch_to_debug
      send_request( "device/mode", :mode => 1 )
    end
  end
  module Modem
    class << self
      def send_modem( str )
        sp = SerialPort.new('/dev/ttyUSB0',115200)
        sp.write("#{str}\r\n")
        sp.read_timeout = 100
        sp.readlines
      end

      def switch_to_hilink
        send_modem( "AT^U2DIAG=119" )
      end
    end
  end
  module Monitoring
    class << self
      def send_request( path, request = {} )
        Hilink::send_request( "monitoring/#{path}", request )
      end

      def traffic_statistics
        send_request( "traffic-statistics" )
      end

      def traffic_reset
        send_request( "clear-traffic" )
      end

      def status
        send_request( "status" )
      end

      def check_notifications
        send_request( "check-notifications" )
      end
    end
  end
  module Network
    class << self
      def send_request( path, request = {} )
        Hilink::send_request( "net/#{path}", request )
      end

      def current_plnm
        send_request( "current-plnm" )
      end

      def set_connection_type( mode = 'auto', band: '-1599903692' )
        nmode = case mode
        when /2g/i 
         1 
        when /3g/i 
         2 
        else 
         0 
        end
        send_request( "network", {
          :NetworkMode => nmode,
          :NetworkBand => band } )
      end
    end
  end
  module SMS
    class << self
      def send_request( path, request = {} )
        Hilink::send_request( "sms/#{path}", request )
      end

      def list( box = 1, site: 1, pref_unread: 0, count: 20 )
        ret = send_request( "sms-list", {
          :PageIndex => site,
          :ReadCount => count,
          :BoxType => box,
          :SortType => 0,
          :Ascending => 0,
          :UnreadPreferred => pref_unread } )
        if ret['Messages']['Message'].class == Hash
          ret['Messages']['Message'] = [ ret['Messages']['Message'] ]
        end
        ret
      end

      def delete( index )
        send_request( "delete-sms", { :Index => index } )
      end

      def send( number, message, index = -1 )
        send_request( "send-sms", {
          :Index => index,
          :Phones => [number].flatten,
          :Sca => "",
          :Content => message,
          :Length => message.length,
          :Reserved => 1,
          :Date => Time.now.strftime( "%Y-%m-%d %H:%M:%S" ) } )
      end
    end
  end
  module Dialup
    class << self
      def send_request( path, request = {} )
        Hilink::send_request( "dialup/#{path}", request )
      end

      def connect
        send_request( "dial", :Action => 1 )
      end

      def disconnect
        send_request( "dial", :Action => 0 )
      end
    end
  end
  module USSD
    class << self
      def send_request( path, request = {} )
        Hilink::send_request( "ussd/#{path}", request )
      end

      def send( str )
        send_request( "send", :content => str, :codeType => "CodeType" )
      end
    end
  end
end

#puts Hilink::USSD::send( "*100#" )
#exit

#puts Hilink::switch_to_debug
#exit

puts Hilink::Modem::switch_to_hilink
exit

puts Hilink::switch_to_modem
exit

puts Hilink::Dialup::connect
puts Hilink::Dialup::disconnect
exit


#puts Hilink::SMS::send( "93999699", "hello there" )
puts Hilink::SMS::list.inspect
Hilink::SMS::list['Messages']['Message'].each{|m|
  puts m.inspect
  Hilink::SMS::delete( m['Index'] )
}
exit

#puts Hilink::send_request( "device/information" )
message = "Hello from Smileplug"
=begin
puts Hilink::send_request( "sms/send-sms", 
{ :Index => -1, 
  :Phones => ["93999699"],
  :Sca => '',
  :Content => message,
  :Length => message.length,
  :Reserved => 1,
  :Date => Time.now.strftime('%Y-%m-%d %H:%M:%S') } )
=end
#puts Hilink::send_request( "monitoring/check-notifications" )
#puts Hilink::send_request( "monitoring/status" )
puts Hilink::send_request( "sms/sms-list",
{ :PageIndex => 1,
  :ReadCount => 20,
  :BoxType => 1,
  :SortType => 0,
  :Ascending => 0,
  :UnreadPreferred => 0 } )
puts Hilink::send_request( "sms/delete-sms", { :Index => 20067 } )

exit

a = Document.new
( a.add_element "Index" ).text = -1
a.write $stdout

exit

url = 'http://192.168.1.1/api/monitoring/status'
url = 'http://192.168.1.1/api/device/information'

# get the XML data as a string
xml_data = Net::HTTP.get_response(URI.parse(url)).body

puts xml_data.inspect
# extract event information
doc = REXML::Document.new(xml_data)

XPath.each( doc, "//response/*" ){|a|
  puts a.inspect, a.text
}
