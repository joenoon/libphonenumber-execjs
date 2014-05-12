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
          var _isValid = phoneUtil.isValidNumber(number);
          var _is_reason = null;
          for(reason in VR){
            if (_r == VR[reason]){
              _is_reason = reason;
              break;
            }
          }
          m = phoneUtil.parse(a,b);
          parsing_result = {}
          for(f in m.fields_){
            parsing_result[m.fields_[f].name_] = m.values_[m.fields_[f].tag_] || null
          }
          return {
            util: {values_ : m.values_},
            country: phoneUtil.getRegionCodeForNumber(number),
            type: phoneUtil.getNumberType(number),
            e164_number: phoneUtil.format(number, 0),
            national_format: phoneUtil.format(number, 1),
            is_possible_number: phoneUtil.isPossibleNumber(number),
            validation_reasult: _is_reason,
            is_valid: _isValid,
            out_of_country_us_format: phoneUtil.formatOutOfCountryCallingNumber(number, "US"),
            parsing_result: parsing_result
          };
        }catch(e){
          return {
            message: e,
            error: true
          }
        }
      })
    ', str, default_region
    if @parse['util']
      tmp = []
      @parse['util']['values_'].map{|k,v| tmp[k] = v}
      @parse['util']['values_'] = tmp
    end
    @parse.to_openstruct
  end

  def read_data(t='geocoding',a=nil, b=nil)
    self.parse(a,b) if @parse.nil?
    region_of_number = 'UNKNOWN'
    if @parse['e164_number'].nil?
    else
      cc = @parse['util']['values_'][1]
      code = @parse['e164_number']
      region_file = File.join(File.dirname(__FILE__), "..", "..", "support", t, "en", "#{cc}.txt")
      if File.exists? region_file
        content = File.read(region_file)
        content = content.split("\n\n")
        content = content.last.split("\n").reverse
        content.each { |e|
          _e = e.split('|')
          # puts "#{_e[0]}=#{_e[1]}"
          if code[1, _e[0].to_s.length] == _e[0]
            region_of_number = _e[1]
            break
          end
        }
      else
      end
    end
    region_of_number
  end

  def region(a=nil,b=nil)
    read_data('geocoding',a,b)
  end

  def carrier(a=nil,b=nil)
    read_data('carrier',a,b)
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