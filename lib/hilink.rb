require 'net/http'
#require 'active_support/core_ext'
#require 'active_support'
require 'serialport'
require 'helperclasses/hashaccessor'


module Hilink
  extend self
  #using HelperClasses::HashAccessor

  def send_request( path, request = {} )
    url = "/api/#{path}"
    http = Net::HTTP.new('192.168.1.1')

    if request != {} 
      req = Net::HTTP::Post.new(url)
      req.body = request.to_xml(root: 'request', indent: 0, skip_types: true)
      req.content_type = 'text/xml'
    else
      req = Net::HTTP::Get.new(url)
    end
    begin
      response = http.request(req).body
    rescue Errno::ENETUNREACH => e
      return nil
    end

    begin
      Hash.from_xml( response )['response']
    rescue REXML::ParseException => e
      nil
    end
  end

  def switch_to_modem
    send_request( 'device/mode', :mode => 0 )
  end

  def switch_to_debug
    send_request( 'device/mode', :mode => 1 )
  end
  module Modem
    extend self
    
    def send_modem( str )
      sp = SerialPort.new('/dev/ttyUSB0',115200)
      sp.write("#{str}\r\n")
      sp.read_timeout = 100
      sp.readlines
    end

    def switch_to_hilink
      send_modem('AT^U2DIAG=119')
    end

    def save_modem
      send_modem('AT^U2DIAG=0')
    end
  end
  module Monitoring
    extend self
    
    def send_request( path, request = {} )
      Hilink::send_request( "monitoring/#{path}", request )
    end

    def traffic_statistics
      send_request('traffic-statistics')
    end

    def traffic_reset
      send_request('clear-traffic')
    end

    def status
      send_request('status')
    end

    def check_notifications
      send_request('check-notifications')
    end
  end
  module Network
    extend self
    
    def send_request( path, request = {} )
      Hilink::send_request( "net/#{path}", request )
    end

    def current_plnm
      send_request('current-plnm')
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
      send_request( 'network', {
          :NetworkMode => nmode,
          :NetworkBand => band } )
    end
  end
  module SMS
    extend self
    
    def send_request( path, request = {} )
      Hilink::send_request( "sms/#{path}", request )
    end

    def list( box = 1, site: 1, pref_unread: 0, count: 20 )
      ret = send_request( 'sms-list', {
          :PageIndex => site,
          :ReadCount => count,
          :BoxType => box,
          :SortType => 0,
          :Ascending => 0,
          :UnreadPreferred => pref_unread } )
      if ret && ret['Messages']['Message'].class == Hash
        ret['Messages']['Message'] = [ ret['Messages']['Message'] ]
      end
      ret
    end

    def delete( index )
      send_request( 'delete-sms', { :Index => index } )
    end

    def send( number, message, index = -1 )
      send_request( 'send-sms', {
          :Index => index,
          :Phones => [number].flatten,
          :Sca => "",
          :Content => message,
          :Length => message.length,
          :Reserved => 1,
          :Date => Time.now.strftime('%Y-%m-%d %H:%M:%S') } )
    end
  end
  module Dialup
    extend self
    
    def send_request( path, request = {} )
      Hilink::send_request( "dialup/#{path}", request )
    end

    def connect
      send_request( 'dial', :Action => 1 )
    end

    def disconnect
      send_request( 'dial', :Action => 0 )
    end
  end
  module USSD
    extend self 
    
    def send_request( path, request = {} )
      Hilink::send_request( "ussd/#{path}", request )
    end

    def send( str )
      return :error => "Sorry, doesn't work!"
      send_request( 'send', :content => str, :codeType => 'CodeType')
    end
  end
end
