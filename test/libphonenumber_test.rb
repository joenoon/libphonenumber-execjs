require 'bundler'
Bundler.require(:default, :development)
require "minitest/autorun"

class LibphonenumberTest < MiniTest::Spec

  SCENARIOS = [
    {
      :given => {
        :number => "9255550100",
        :cc => "US",
        :ndc => "925"
      },
      :expected => {
        :normalized => "9255550100",
        :e164 => "+19255550100"
      }
    },
    {
      :given => {
        :number => "19255550100",
        :cc => 1
      },
      :expected => {
        :normalized => "19255550100",
        :e164 => "+19255550100"
      }
    },
    {
      :given => {
        :number => "5550100",
        :cc => "US",
        :ndc => "925"
      },
      :expected => {
        :normalized => "5550100",
        :e164 => "+19255550100"
      }
    },
    {
      :given => {
        :number => "5550100",
        :ndc => "925"
      },
      :expected => {
        :normalized => "5550100",
        :e164 => nil
      }
    },
    {
      :given => {
        :number => "5550100",
        :cc => "US"
      },
      :expected => {
        :normalized => "5550100",
        :e164 => nil
      }
    },
    {
      :given => {
        :number => " (925) 555 - 0100",
        :cc => "US",
        :ndc => "925"
      },
      :expected => {
        :normalized => "9255550100",
        :e164 => "+19255550100"
      }
    },
    {
      :given => {
        :number => " 1 (925) 555-0100",
        :cc => 1
      },
      :expected => {
        :normalized => "19255550100",
        :e164 => "+19255550100"
      }
    },
    {
      :given => {
        :number => "1.925.555.0100",
        :cc => 1
      },
      :expected => {
        :normalized => "19255550100",
        :e164 => "+19255550100"
      }
    },
    {
      :given => {
        :number => "925.555.0100",
        :cc => 1
      },
      :expected => {
        :normalized => "9255550100",
        :e164 => "+19255550100"
      }
    },
    {
      :given => {
        :number => "  555.0100  ",
        :cc => "US",
        :ndc => "925"
      },
      :expected => {
        :normalized => "5550100",
        :e164 => "+19255550100"
      }
    }
  ]
  
  describe "libphonenumber" do
    before do
      @lib = Libphonenumber.new
    end
    
    it "does expose goog" do
      @lib.context.exec("return ('goog' in this);").must_equal true
    end

    it "does expose i18n" do
      @lib.context.exec("return ('i18n' in this);").must_equal true
    end

    it "does expose getE164PhoneNumber" do
      @lib.context.exec("return ('getE164PhoneNumber' in this);").must_equal true
    end

    it "does not expose CLOSURE_NO_DEPS" do
      @lib.context.exec("return ('CLOSURE_NO_DEPS' in this);").must_equal false
    end

    it "does not expose COMPILED" do
      @lib.context.exec("return ('COMPILED' in this);").must_equal false
    end

    SCENARIOS.each do |scenario|
      d = "given #{scenario[:given].inspect}"
      describe d do
        it "will normalize the number correctly" do
          @lib.normalize(scenario[:given][:number]).must_equal(scenario[:expected][:normalized], d)
        end
        it "will parse the e164 formatted version correctly" do
          @lib.simple.get_e164_phone_number(scenario[:given][:number], scenario[:given][:cc], scenario[:given][:ndc]).must_equal(scenario[:expected][:e164], d)
        end
      end
    end
  end
  
end
