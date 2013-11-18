require 'spec_helper'
include RandomSet

describe Template do

  let(:template) { Template.new([]) }

  describe '#hash?' do
    it "should be true if the passed in argument was a hash" do
      expect(Template.new({})).to be_hash
    end
    it "should be false if anything else was passed in" do
      expect(Template.new([])).not_to be_hash
    end
  end

  describe '#generators' do

    it "should be a hash, regardless of the template's input" do
      expect(Template.new({}).generators).to be_a(Hash)
      expect(Template.new([]).generators).to be_a(Hash)
    end

    it "should contain a resolved generator for each item in the templates" do
      item1 = (1..5)
      item2 = ->{}

      generators = Template.new([item1, item2]).generators
      expect(generators).to have(2).items
      expect(generators[0]).to be_a(Enumerator)
      expect(generators[1]).to be_a(CustomGenerator)
    end

    it "should contain a resolved generator for each item in the templates" do
      item1 = (1..5)
      item2 = ->{}

      generators = Template.new(:item1 => item1, :item2 => item2).generators
      expect(generators).to have(2).items
      expect(generators[:item1]).to be_a(Enumerator)
      expect(generators[:item2]).to be_a(CustomGenerator)
    end

  end

  describe '#count' do
    it "should be the maximum count for all generators that return a count" do
      generator1 = double(:count => 2, :next => nil)
      generator2 = double(:count => 5, :next => nil)
      generator3 = double(:next => nil)
      template = Template.new([generator1, generator2, generator3])
      expect(template.count).to eql(5)
    end

    it "should return nil if no generators had a count method" do
      generator1 = double(:next => nil)
      generator2 = double(:next => nil)
      generator3 = double(:next => nil)
      template = Template.new([generator1, generator2, generator3])
      expect(template.count).to be_nil
    end
  end

  describe '#generate' do
    let(:template) { Template.new([]) }

    it "should raise an error if no count was provided, and no count could be inferred" do
      expect(template).to receive(:count).and_return(nil)
      expect{ template.generate }.to raise_error(CannotInferCount, 'no count was specified or could be inferred')
    end

    it "should output <template.count> records if no count is specified" do
      expect(template).to receive(:count).and_return(5)
      expect(template.generate).to have(5).items
    end

    it "should output <count> records if a count is specified" do
      allow(template).to receive(:count).and_return(5)
      expect(template.generate(10)).to have(10).items
    end

    # Other generation examples in the integration specs.
  end

  describe 'generator resolution' do

    it "should resolve a range to its enumerator" do
      generator = Template.new([ (1..5) ]).generators[0]
      expect(generator).to be_a(Enumerator)
      expect(generator.map { |i| i }).to eql([1,2,3,4,5])
    end

    it "should resolve an array to its enumerator" do
      generator = Template.new([ [1,2,3] ]).generators[0]
      expect(generator).to be_a(Enumerator)
      expect(generator.map { |i| i }).to eql([1,2,3])
    end

    it "should resolve a block into a CustomGenerator" do
      block = ->{}
      generator = Template.new([ block ]).generators[0]
      expect(generator).to be_a(CustomGenerator)
      expect(generator.block).to be(block)
    end

    it "should resolve anything with an 'each' method to the result of that method" do
      enumerator = double()
      generator = Template.new([ double(:each => enumerator) ]).generators[0]
      expect(generator).to be(enumerator)
    end

    it "should resolve anything with a 'next' method to itself" do
      generator = double(:next => nil)
      expect(Template.new([ generator ]).generators[0]).to be(generator)
    end

    it "should raise an error for something else" do
      expect{ Template.new([ Object.new ]) }
        .to raise_error(UnsupportedTemplate, "cannot create a generator for a template of class Object")
    end

  end


end