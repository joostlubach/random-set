require 'spec_helper'

describe "RandomSet generation" do

  context "specifying an empty template" do

    it "should require a count" do
      expect{ RandomSet.generate([]) }.to raise_error(RandomSet::CannotInferCount)
    end

    it "should output X empty records" do
      data = RandomSet.generate(5, [])

      expect(data).to have(5).items
      expect(data[0]).to be_empty
      expect(data[1]).to be_empty
      expect(data[2]).to be_empty
      expect(data[3]).to be_empty
      expect(data[4]).to be_empty
    end

  end

  context "specifying a hash template" do

    it "should output a list of hashes" do
      expect(RandomSet.generate(5, {})).to eql([ {}, {}, {}, {}, {} ])
    end

    it "should fill in key-by-key" do
      expect(RandomSet.generate(2, { :name => -> { 'Test' }, :age => (1..2) })).to eql([
        { :name => 'Test', :age => 1 },
        { :name => 'Test', :age => 2 }
      ])
    end

  end

  context "specifying an array template" do

    it "should output a list of arrays" do
      expect(RandomSet.generate(5, [])).to eql([ [], [], [], [], [] ])
    end

    it "should fill in index by index" do
      expect(RandomSet.generate(2, [ -> { 'Test' }, (1..2) ])).to eql([
        ['Test', 1], ['Test', 2]
      ])
    end

  end

  describe 'full example' do

    let(:custom_generator1) do
      Class.new do
        def initialize
          @iteration = 0
        end
        def next
          "Iteration #{@iteration}"
        ensure
          @iteration += 1
        end
      end.new
    end

    let :custom_generator2 do
      Class.new do
        def next; 'Same' end
        def count; 3 end
      end.new
    end

    it "should infer the count from all generators that support counts" do
      data = RandomSet.generate([custom_generator1, custom_generator2])
      expect(data).to have(3).items
    end

    it "should generate ranges, arrays, procs, and custom generators" do
      data = RandomSet.generate(5, [ custom_generator1, (1..10), [1,2,3], ->(n) { "Item #{n}" } ])
      expect(data).to eql([
        ['Iteration 0', 1, 1,   'Item 0'],
        ['Iteration 1', 2, 2,   'Item 1'],
        ['Iteration 2', 3, 3,   'Item 2'],
        ['Iteration 3', 4, nil, 'Item 3'],
        ['Iteration 4', 5, nil, 'Item 4']
      ])
    end


  end


end