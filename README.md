# Twilio TaskRouter Example

This repo contains a working example usage of Twilio's TaskRouter with the `twilio-ruby` 5.6.4 gem.

Built from [Twilio's TaskRouter Ruby Quickstart](https://www.twilio.com/docs/quickstart/ruby/taskrouter#overview).

As of this writing (2018-03-04), it has been a horrendous pain following this quickstart guide as the code examples didn't match the latest API offered by the [twilio-ruby gem](https://github.com/twilio/twilio-ruby).

The following pages helped me understand how to translate the old and not functional code examples into code that works with version 5.6.4 of the `twilio-ruby` gem.

- [The README](https://github.com/twilio/twilio-ruby/blob/master/README.md)
- [v4 to v5 upgrade guide](https://github.com/twilio/twilio-ruby/wiki/Ruby-Version-5.x-Upgrade-Guide)
- [Twilio JWT Tokens](https://github.com/twilio/twilio-ruby/wiki/JWT-Tokens)
- [Twilio JWT docs](https://www.twilio.com/docs/api/taskrouter/constructing-jwts)
- [TwiML](https://github.com/twilio/twilio-ruby/wiki/TwiML)

## Running

_Tested with Ruby 2.4.1_

`bundle install` then `ruby server.rb`
