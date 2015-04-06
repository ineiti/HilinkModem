Gem::Specification.new do |s|
  s.name        = 'HilinkModem'
  s.version     = '0.2.0'
  s.date        = '2015-04-06'
  s.summary     = 'Accessing Huawei HilinkModem modems'
  s.description = 'Using the web-interface of huawei hilink modems to do things'
  s.authors     = ['Linus Gasser']
  s.email       = 'ineiti@linusetviviane.ch'
  s.files       = %w(lib/hilinkmodem.rb README.md)
  s.add_runtime_dependency 'activesupport', '~> 4.1'
  s.add_runtime_dependency 'serialport', '~> 1.3'
  s.homepage    = 'https://github.com/ineiti/HilinkModem'
  s.license       = 'GPLv3'
end
