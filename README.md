# Hilink - ruby interface for Huawei Hilink web-frontend

## Usage

The code supposes that the modem is connected and has the IP
192.168.1.1. Then you can do:

  require 'hilink'
  puts Hilink::Monitoring::status.inspect

which will return a hash of all variables that the stick can return.

## Commands

Each command is a module inside of Hilink. There are different modules:

- Monitoring
- Network
- SMS
- Dialup
