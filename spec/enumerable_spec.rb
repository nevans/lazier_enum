require "spec_helper"

module Lazier

  RSpec.describe Enumerable do

    it "should implement all of the methods in stdlib Enumerable" do
      stdlib = ::Enumerable.instance_methods.sort_by(&:to_s)
      lazier = Enumerable.instance_methods.sort_by(&:to_s)
      expect(lazier).to include(*stdlib)
    end

  end

end

