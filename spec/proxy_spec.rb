require "spec_helper"

module Lazier::Proxy

  describe Indexed do

    # using local variables to allow meta-programming
    nested_h = { f: 1, g: ["foo", "bar"] }
    resource = { a: nil, b: 123, c: 4.5, d: "str", e: nested_h }

    contexts = {

      "non-existent field" => {
        path: [:z], force: nil, to_a: [], to_h: {},
      },

      "nil field" => {
        path: [:a], force: nil, to_a: [], to_h: {},
      },

      "integer field" => {
        path: [:b], force: 123, to_a: [123], to_h: TypeError,
      },

      "float field" => {
        path: [:c], force: 4.5, to_a: [4.5], to_h: TypeError,
      },

      'string field' => {
        path: [:d], force: "str", to_a: ["str"], to_h: TypeError,
      },

      "nested hash" => {
        path: [:e], force: nested_h, to_h: nested_h, to_a: nested_h.to_a,
      },

      "dig into nested hash" => {
        path: [:e, :f], force: 1, to_a: [1], to_h: TypeError
      },

      "dig deeply into nested hash" => {
        path: [:e, :g], force: %w[foo bar], to_a: %w[foo bar], to_h: TypeError
      },

      "dig deeply into nested hash and array" => {
        path: [:e, :g, 0], force: "foo", to_a: ["foo"], to_h: TypeError
      },

      "dig beyond existing data" => {
        path: [:e, :g, 3], force: nil, to_a: [], to_h: {}
      },

      "dig into string" => {
        path: [:e, :g, 0, 2], force: TypeError, to_a: TypeError, to_h: TypeError
      }

    }

    before(:each) do
      # allow spies
      allow(resource).to receive(:[]).and_call_original
    end

    contexts.each do |name, values|
      path   = values.fetch(:path)
      to_a   = values.fetch(:to_a)
      to_h   = values.fetch(:to_h)
      force = values.fetch(:force)
      desc_path = path.map(&:to_s).join(".")
      desc_force = values.fetch(:desc_force) { force.inspect }
      desc_a = values.fetch(:desc_a) { to_a.inspect }
      desc_h = values.fetch(:desc_h) { to_h.inspect }

      context "#{name} (#{desc_path})" do

        subject(:proxy) { Indexed.new(resource, *path) }

        if force.is_a?(Class) && Exception >= force
          specify "#force raises #{desc_force}" do
            expect{subject.force}.to raise_error(force)
            expect(resource).to have_received(:[])
          end
        else
          specify "#force returns #{desc_force}" do
            expect(subject.force).to eq(force)
            expect(resource).to have_received(:[])
          end
        end

        if to_a.is_a?(Class) && Exception >= to_a
          specify "#to_a raises #{desc_h}" do
            expect{subject.to_a}.to raise_error(to_a)
          end
        else
          specify "#to_a returns #{desc_a}" do
            expect(subject.to_a).to eq(to_a)
            expect(resource).to have_received(:[])
          end
        end

        if to_h.is_a?(Class) && Exception >= to_h
          specify "#to_h raises #{desc_h}" do
            expect{subject.to_h}.to raise_error(to_h)
          end
        else
          specify "#to_h returns #{desc_h}" do
            expect(subject.to_h).to eq(to_h)
            expect(resource).to have_received(:[])
          end
        end

      end

    end

  end

end
