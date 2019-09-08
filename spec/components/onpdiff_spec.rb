# frozen_string_literal: true

require 'rails_helper'
require 'onpdiff'

describe Onpdiff do

  describe "diff" do

    it "returns an empty array when there is no content to diff" do
      expect(Onpdiff.new("", "").diff).to eq([])
    end

    it "returns an array with the operation code for each element" do
      expect(Onpdiff.new("abcd", "abef").diff).to eq([["a", :common], ["b", :common], ["e", :add], ["f", :add], ["c", :delete], ["d", :delete]])
    end

    it "bails out on large diffs" do
      a = SecureRandom.alphanumeric(5_000)
      b = SecureRandom.alphanumeric(5_000)
      expect(Onpdiff.new(a, b).diff).to eq([])
    end

  end

  describe "short_diff" do

    it "returns an empty array when there is no content to diff" do
      expect(Onpdiff.new("", "").short_diff).to eq([])
    end

    it "returns an array with the operation code for each element" do
      expect(Onpdiff.new("abc", "acd").short_diff).to eq([["a", :common], ["b", :delete], ["c", :common], ["d", :add]])
    end

    it "returns an array with sequencially similar operations merged" do
      expect(Onpdiff.new("abcd", "abef").short_diff).to eq([["ab", :common], ["ef", :add], ["cd", :delete]])
    end

  end

end
