require 'hilinkmodem'

puts HilinkModem::switch_to_modem
sleep 10
if File.exists? "/dev/ttyUSB0"
  puts HilinkModem::Modem::save_modem
else
  puts "Switch didn't work - sorry"
end
