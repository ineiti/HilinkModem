Gem::Specification.new do |s|
  s.name        = 'hilink_modem'
  s.version     = '0.3.1'
  s.date        = '2015-04-06'
  s.summary     = 'Accessing Huawei HilinkModem modems'
  s.description = 'Using the web-interface of huawei hilink modems to do things'
  s.authors     = ['Linus Gasser']
  s.email       = 'ineiti@linusetviviane.ch'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_runtime_dependency 'activesupport', '~> 3.1'
  s.add_runtime_dependency 'serialport', '~> 1.3'
  s.homepage    = 'https://github.com/ineiti/HilinkModem'
  s.license       = 'GPLv3'
end
