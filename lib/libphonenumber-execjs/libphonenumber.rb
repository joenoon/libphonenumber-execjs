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
    context.call "i18n.phonenumbers.PhoneNumberUtil.getInstance().parse", str, default_region
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
    
  end
  
end
