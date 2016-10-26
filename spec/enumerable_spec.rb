require "spec_helper"

module Lazier

  RSpec.describe Enumerable do

    it "should implement all of the methods in stdlib Enumerable" do
      stdlib = ::Enumerable.instance_methods.sort_by(&:to_s)
      lazier = Enumerable.instance_methods.sort_by(&:to_s)
      expect(lazier).to include(*stdlib)
    end

    class LazyListTest
      def initialize(enum) @enum = enum end
      extend Forwardable
      def_delegator :@enum, :each
      include ::Lazier::Enumerable
    end

    describe "enumeration methods" do
      let(:lazy_list) { LazyListTest.new(1.upto(100)) }

      block_methods = Enumerable::ENUMERATION_METHODS - [
        :drop, :grep, :take, :zip
      ]

      shared_examples "generic enumeration method" do
        it "returns a stdlib lazy enumerator" do
          expect(subject).to be_an(::Enumerator::Lazy)
        end
        it "can be chained with other lazy methods" do
          block_methods.each do |m2|
            chained = subject.send(m2) {|i| i + 4 }
              .drop(2).grep(Integer).take(5)
            expect(chained).to be_an(::Enumerator::Lazy)
          end
        end
        it "returns the same from #force and #to_a" do
          expect(subject.force).to eq(subject.to_a)
        end
      end

      block_methods.each do |m|
        describe "##{m}" do
          subject { lazy_list.send(m) {|i| i + 2 } }
          include_examples "generic enumeration method"
        end
      end

      describe "#drop" do
        subject { lazy_list.drop(96) }
        include_examples "generic enumeration method"
        it "works when forced" do
          forced = subject.map {|i| i*2 }.force
          expect(forced).to eq([194, 196, 198, 200])
        end
      end

      describe "#grep" do
        subject { lazy_list.grep(Integer) }
        include_examples "generic enumeration method"
      end

      describe "#take" do
        subject { lazy_list.take(2) }
        include_examples "generic enumeration method"
      end

      describe "#zip" do
        subject { lazy_list.zip(LazyListTest.new(100.downto(1))) }
        include_examples "generic enumeration method"
      end

    end

  end

end

