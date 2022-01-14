require "./spec_helper"

describe Difftance do
  it "has constant VERSION" do
    Difftance::VERSION.should be_a(String)
  end
end
