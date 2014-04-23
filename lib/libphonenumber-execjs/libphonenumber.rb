class Libphonenumber
  
  attr_reader :context
  
  def initialize
    @context = ExecJS.compile(File.read(File.join(File.dirname(__FILE__), "..", "..", "support", "libphonenumber.js")))
  end
  
  def extractPossibleNumber(str="")
    context.call "i18n.phonenumbers.PhoneNumberUtil.extractPossibleNumber", str
  end
  
  def normalize(str="")
    context.call "i18n.phonenumbers.PhoneNumberUtil.normalize", str
  end
  
  def parse(str="", default_region="ZZ")
    #context.call "i18n.phonenumbers.PhoneNumberUtil.getInstance().parse", str, default_region
    @parse = context.call '(function (a,b) {
        try{
          var phoneUtil = i18n.phonenumbers.PhoneNumberUtil.getInstance();
          var number = phoneUtil.parseAndKeepRawInput(a, b);
          var VR = i18n.phonenumbers.PhoneNumberUtil.ValidationResult;
          var _r = phoneUtil.isPossibleNumberWithReason(number);
          var _is_reason = null;
          for(reason in VR){
            if (_r == VR[reason]){
              _is_reason = reason;
              break;
            }
          }
          return {
            util: phoneUtil.parse(a,b),
            country: phoneUtil.getRegionCodeForNumber(number),
            type: phoneUtil.getNumberType(number),
            e164_number: phoneUtil.format(number, 0),
            is_possible_number: phoneUtil.isPossibleNumber(number),
            validation_reasult: _is_reason
          };
        }catch(e){
          return {
            message: e,
            error: true
          }
        }
      })
    ', str, default_region
    @parse
  end

  def region(a=nil, b=nil)
    self.parse(a,b) if @parse.nil?
    region_of_number = 'UNKNOWN'
    if @parse[:e164_number].nil?
    else
      cc = @parse["util"]["values_"][1]
      region_file = File.join(File.dirname(__FILE__), "..", "..", "support", "geocoding", "en", "#{cc}.txt")
      if File.exists? region_file
        content = File.read(region_file)
        content = content.split("\n\n")
        content = content.last.split("\n")
        region_map = {}
        content.each { |e|  
          _e = e.split('|')
          region_map[_e[0]] = _e[1]
        }
        region_map = region_map.reverse
        region_map.each { |num, reg|  
          if cc[1,num.length]==num
            region_of_number = reg
            break
          end
        }
      else
      end
    end
    region_of_number
  end
  
  def simple
    @simple ||= Simple.new(self)
  end
  
  class Simple
    
    def initialize(libphonenumber)
      @libphonenumber = libphonenumber
      @context = @libphonenumber.context
    end
    
    def get_e164_phone_number(str, cc=nil, ndc=nil)
      @context.call "getE164PhoneNumber", str, cc, ndc
    end

    def get_e164_phone_number_with_meta(str, cc=nil, ndc=nil)
      @context.call "getE164PhoneNumberWithMeta", str, cc, ndc
    end
    
  end
  
end
