# libphonenumber-execjs

ExecJS wrapper for Google's libphonenumber library

## Installation

Gemfile:

    gem 'libphonenumber-execjs', :github => 'hrishabhz/libphonenumber-execjs'

## Getting Started

    libphonenumber = Libphonenumber.new

Currently, only 3 functions are exposed directly:

    libphonenumber.parse("7893461649", "IN") # => {"util"=>{"values_"=>{1=>91, 2=>7893461642.0}, "fields_"=>{1=>{"tag_"=>"1", "name_"=>"country_code", "isRepeated_"=>false, "isRequired_"=>true, "fieldType_"=>5, "deserializationConversionPermitted_"=>false, "defaultValue_"=>nil}, 2=>{"tag_"=>"2", "name_"=>"national_number", "isRepeated_"=>false, "isRequired_"=>true, "fieldType_"=>4, "deserializationConversionPermitted_"=>true, "defaultValue_"=>nil}, 3=>{"tag_"=>"3", "name_"=>"extension", "isRepeated_"=>false, "isRequired_"=>false, "fieldType_"=>9, "deserializationConversionPermitted_"=>false, "defaultValue_"=>nil}, 4=>{"tag_"=>"4", "name_"=>"italian_leading_zero", "isRepeated_"=>false, "isRequired_"=>false, "fieldType_"=>8, "deserializationConversionPermitted_"=>false, "defaultValue_"=>nil}, 5=>{"tag_"=>"5", "name_"=>"raw_input", "isRepeated_"=>false, "isRequired_"=>false, "fieldType_"=>9, "deserializationConversionPermitted_"=>false, "defaultValue_"=>nil}, 6=>{"tag_"=>"6", "name_"=>"country_code_source", "isRepeated_"=>false, "isRequired_"=>false, "fieldType_"=>14, "nativeType_"=>{"FROM_NUMBER_WITH_PLUS_SIGN"=>1, "FROM_NUMBER_WITH_IDD"=>5, "FROM_NUMBER_WITHOUT_PLUS_SIGN"=>10, "FROM_DEFAULT_COUNTRY"=>20}, "deserializationConversionPermitted_"=>false, "defaultValue_"=>1}, 7=>{"tag_"=>"7", "name_"=>"preferred_domestic_carrier_code", "isRepeated_"=>false, "isRequired_"=>false, "fieldType_"=>9, "deserializationConversionPermitted_"=>false, "defaultValue_"=>nil}, 8=>{"tag_"=>"8", "name_"=>"number_of_leading_zeros", "isRepeated_"=>false, "isRequired_"=>false, "fieldType_"=>5, "deserializationConversionPermitted_"=>false, "defaultValue_"=>1}}, "lazyDeserializer_"=>nil, "deserializedFields_"=>nil}, "country"=>"IN", "type"=>1, "e164_number"=>"+917893461642", "national_format"=>"+91 78 93 461642", "is_possible_number"=>true, "validation_reasult"=>"IS_POSSIBLE", "is_valid"=>true, "out_of_country_us_format"=>"011 91 78 93 461642"}
    
    libphonenumber.region # => Andhra Pradesh
    libphonenumber.carrier # => Airtel
    
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
