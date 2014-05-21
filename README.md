# Hilink - ruby interface for Huawei Hilink web-frontend

## Usage

The code supposes that the modem is connected and has the IP
192.168.1.1. Then you can do:

````
require 'hilink'
puts Hilink::Monitoring::status.inspect
````

which will return a hash of all variables that the stick can return.

Please also see the much more complete PhP-implementation on
[BlackyPanther/Huawei-HiLink](https://github.com/BlackyPanther/Huawei-HiLink).

## Commands

Each command is a module inside of Hilink. There are different modules:

- Monitoring - return different status of the modem
- Network - change 2g / 3g network
- SMS - send, receive and list
- Dialup - (dis)connect from network
- Modem - useful only when it is in modem-mode
- USSD - *Doesn't work due to Huawei restriction*

The Hilink-module itself has three methods:
- `send_request( path, request = {} )` - generates a valid XML-request and return
the result as a hash
- `switch_to_modem` - sends the command so the key behaves as a modem
- `switch_to_debug` - according to web-interface, no difference visible

### Monitoring

You can monitor different things:

- `traffic_statistics` - per-connection and total usage
- `traffic_reset` - set all to 0
- `status` - shows whether connected or not
- `check_notifications`

### Network

- `set_connection_type( mode = 'auto', band = '-1599903692' )` - mode
can be 'auto', '2g' or '3g'
- `current_plnm` - get actual connection

### SMS

- `list`
