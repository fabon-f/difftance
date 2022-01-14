require "./spec_helper"

describe Difftance::EditDistance do
  describe ".edit_distance" do
    it "correctly returns edit distance of two strings" do
      Difftance::EditDistance.edit_distance("before", "after").should eq(5)
    end

    it "correctly returns edit distance with specified costs" do
      Difftance::EditDistance.edit_distance("before", "after", { insertion: 2, deletion: 2, substitution: 3 }).should eq(12)
      Difftance::EditDistance.edit_distance("before", "after", { insertion: 1, deletion: 1, substitution: 2 }).should eq(7)
      Difftance::EditDistance.edit_distance("abcdef", "beghi", { insertion: 1, deletion: 0, substitution: 1 }).should eq(3)
    end

    it "treat UTF-8 correctly" do
      Difftance::EditDistance.edit_distance("𩸽", "𠮷").should eq(1)
    end
  end
end
