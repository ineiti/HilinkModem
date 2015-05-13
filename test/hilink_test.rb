require 'hilink_modem'

#puts HilinkModem::USSD::send( "*100#" )
#exit

#puts HilinkModem::switch_to_debug
#exit

#puts HilinkModem::Modem::switch_to_hilink
#puts HilinkModem::SMS::list.inspect
#exit

puts HilinkModem::switch_to_modem
exit

puts HilinkModem::Dialup::connect
puts HilinkModem::Dialup::disconnect
exit


#puts HilinkModem::SMS::send( "93999699", "hello there" )
puts HilinkModem::SMS::list.inspect
HilinkModem::SMS::list['Messages']['Message'].each{|m|
  puts m.inspect
  HilinkModem::SMS::delete( m['Index'] )
}
exit

#puts HilinkModem::send_request( "device/information" )
message = "Hello from Smileplug"
=begin
puts HilinkModem::send_request( "sms/send-sms",
{ :Index => -1, 
  :Phones => ["93999699"],
  :Sca => '',
  :Content => message,
  :Length => message.length,
  :Reserved => 1,
  :Date => Time.now.strftime('%Y-%m-%d %H:%M:%S') } )
=end
#puts HilinkModem::send_request( "monitoring/check-notifications" )
#puts HilinkModem::send_request( "monitoring/status" )
puts HilinkModem::send_request( "sms/sms-list",
{ :PageIndex => 1,
  :ReadCount => 20,
  :BoxType => 1,
  :SortType => 0,
  :Ascending => 0,
  :UnreadPreferred => 0 } )
puts HilinkModem::send_request( "sms/delete-sms", { :Index => 20067 } )

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
