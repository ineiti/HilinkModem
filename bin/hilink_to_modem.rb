#!/usr/bin/env ruby
LOAD_PATH.push %w( ../lib/ ../../HelperClasses/lib ../../QooxView/libs/activesupport-3.1.1/lib
../../QooxView/libs/i18n-0.6.0/lib )
require 'hilink_modem'

puts HilinkModem::switch_to_modem
sleep 10
if File.exists? "/dev/ttyUSB0"
  puts HilinkModem::Modem::save_modem
else
  puts "Switch didn't work - sorry"
end
