# encoding: UTF-8
require 'spec_helper'

module MovableTypeFormat
  describe Parser do
    before(:all) do
      @mt_string = File.read("#{File.dirname(__FILE__)}/../fixtures/example.movable_type").freeze
    end
    describe "parse" do
      before(:each) do
        @entries = Parser.parse(@mt_string)
      end
      subject { @entries }
      it { should be_a Collection }
      context "first entry" do
        before(:each) do
          @entry = @entries.first
        end
        it {
          debugger
          1
        }
      end

    end
  end
end
