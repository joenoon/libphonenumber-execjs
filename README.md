# libphonenumber-execjs

ExecJS wrapper for Google's libphonenumber library

## Installation

Gemfile:

    gem 'libphonenumber-execjs', :github => 'hrishabhz/libphonenumber-execjs'

## Getting Started

    libphonenumber = Libphonenumber.new

Currently, only 3 functions are exposed directly:

    libphonenumber.parse("9255550100", "US", 925)

However, the entire js context of the library is available via the `context` accessor:
    
    libphonenumber.context.call "i18n.phonenumbers.PhoneNumberUtil.extractPossibleNumber", "19255550100"

And two additional functions that I've put together to tie some of these things together in a useful way,
with the goal of trying to get a valid E164 formatted number back or not in one call.

You can pass:

1. Only a string - in this case, it must be complete (e.g. e164 or something you've previously received back).
2. A string and a region code (will accept numbers ("1") or ISO codes ("us", "US").  Will first try like (1), and if not, see if it can be parsed with the fallback region code.
3. A string, a Region Code, and a National Destination Code.  Will first try like (1) and (2), and if not, see if it can be parsed by prefixing the national part with the given ndc.

Example (see tests for more examples):

    libphonenumber.simple.get_e164_phone_number("5550100", "US", "925")  # => "+19255550100"
    libphonenumber.simple.get_e164_phone_number("+19255550100")  # => "+19255550100"

Or to get back an array in the form of [ formatted, cc, ndc ]:

    libphonenumber.simple.get_e164_phone_number_with_meta("+19255550100")  # => [ "+19255550100", "1", "925" ]
    libphonenumber.simple.get_e164_phone_number_with_meta("fake")  # => []

## Development/Recompiling sources

There is a rake task `build_js` in the Rakefile.  You will need the source for google closure, and libphonenumber checked out locally.

See the Rakefile for details.

## Information about libphonenumber

Google's library for dealing with phone numbers

[http://code.google.com/p/libphonenumber/](http://code.google.com/p/libphonenumber/)

## Information about ExecJS

[https://github.com/sstephenson/execjs](https://github.com/sstephenson/execjs)
