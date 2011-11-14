require 'bundler'
Bundler.require(:default, :development)
require "bundler/gem_tasks"

desc "Build the javascript output for libphonenumber.  Needs env variables CLOSURE_PATH and LIBPHONENUMBER_PATH."
task :build_js do
  closure = ENV["CLOSURE_PATH"]
  libphonenumber = ENV["LIBPHONENUMBER_PATH"]
  if !closure
    raise "set CLOSURE_PATH"
  end
  closure = File.join(closure, "")
  if !libphonenumber
    raise "set LIBPHONENUMBER_PATH"
  end
  libphonenumber = File.join(libphonenumber, "")
  cmd = %Q{
    "#{closure}closure/bin/build/closurebuilder.py" \
        --root="#{closure}" \
        --input="#{libphonenumber}javascript/i18n/phonenumbers/phonemetadata.pb.js" \
        --input="#{libphonenumber}javascript/i18n/phonenumbers/phonenumber.pb.js" \
        --input="#{libphonenumber}javascript/i18n/phonenumbers/metadata.js" \
        --input="#{libphonenumber}javascript/i18n/phonenumbers/phonenumberutil.js" \
        --input="#{libphonenumber}javascript/i18n/phonenumbers/asyoutypeformatter.js" \
        --namespace="i18n.phonenumbers.AsYouTypeFormatter" \
        --namespace="i18n.phonenumbers.metadata" \
        --namespace="i18n.phonenumbers.NumberFormat" \
        --namespace="i18n.phonenumbers.PhoneNumberDesc" \
        --namespace="i18n.phonenumbers.PhoneMetadata" \
        --namespace="i18n.phonenumbers.PhoneMetadataCollection" \
        --namespace="i18n.phonenumbers.PhoneNumber" \
        --namespace="i18n.phonenumbers.PhoneNumber.CountryCodeSource" \
        --namespace="i18n.phonenumbers.Error" \
        --namespace="i18n.phonenumbers.PhoneNumberFormat" \
        --namespace="i18n.phonenumbers.PhoneNumberType" \
        --namespace="i18n.phonenumbers.PhoneNumberUtil" \
        --output_mode=script \
        "#{libphonenumber}javascript/i18n/phonenumbers/phonemetadata.pb.js" \
        "#{libphonenumber}javascript/i18n/phonenumbers/phonenumber.pb.js" \
        "#{libphonenumber}javascript/i18n/phonenumbers/metadata.js" \
        "#{libphonenumber}javascript/i18n/phonenumbers/phonenumberutil.js" \
        "#{libphonenumber}javascript/i18n/phonenumbers/asyoutypeformatter.js"
  }
  out = `#{cmd.strip}`
  simple = CoffeeScript.compile(File.read(File.join(File.dirname(__FILE__), "support", "simple.coffee")))
  out = %Q{
(function() {
this.goog = goog = this.goog || {};
this.i18n = i18n = this.i18n || {};
var CLOSURE_NO_DEPS = true;
#{out}
#{simple}
}).call(this);
}
  outfile = File.join(File.dirname(__FILE__), "support", "libphonenumber.js")
  File.open(outfile, "w") do |f|
    f.write out
  end
  puts "Saved to #{outfile}"
end
