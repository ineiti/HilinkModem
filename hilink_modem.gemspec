Gem::Specification.new do |s|
  s.name        = 'hilink_modem'
  s.version = '0.4.0'
  s.date = '2017-10-30'
  s.summary     = 'Accessing Huawei HilinkModem modems'
  s.description = 'Using the web-interface of huawei hilink modems to do things'
  s.authors     = ['Linus Gasser']
  s.email = 'ineiti.blue'

  s.files         = `if [ -d '.git' ]; then git ls-files -z; fi`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_runtime_dependency 'activesupport', '~> 5.1'
  s.add_runtime_dependency 'serialport', '~> 1.3'
  s.homepage    = 'https://github.com/ineiti/HilinkModem'
  s.license = 'GPL-3.0'
end
