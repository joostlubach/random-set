require 'spec_helper'

describe RandomSet do

  describe '.generate' do

    it "should require a template argument" do
      expect{ RandomSet.generate }
        .to raise_error(ArgumentError, "template required")
    end

    it "should not accept more than two arguments" do
      expect{ RandomSet.generate :one, :two, :template }
        .to raise_error(ArgumentError, "too many arguments (1..2 expected)")
    end

    it "should create a template from the last argument and call its generate with the rest of the arguments" do
      template = double(:template)
      expect(RandomSet::Template).to receive(:new).with(:template).and_return(template)

      result = double(:result)
      expect(template).to receive(:generate).with(10).and_return(result)
      expect(RandomSet.generate 10, :template).to be(result)
    end

  end

end