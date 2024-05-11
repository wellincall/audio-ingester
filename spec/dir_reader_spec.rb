# frozen_string_literal: true

require "dir_reader"

RSpec.describe DirReader do
  let(:input_dir) { "input_files" }

  let(:dir_reader) { described_class.new(input_dir) }

  describe "#read" do
    it "returns a hash response" do
    end

    describe "hash response" do
      it "returns success flag as true" do
        response = dir_reader.read

        expect(response[:success]).to eq(true)
      end

      it "returns list of files in data key" do
        response = dir_reader.read

        aggregate_failures do
          expect(response[:data].length).to eq(5)
          expect(response[:data]).to include(
            "sample-file-1.txt",
            "sample-file-2",
            "sample-file-3.wav",
            "sample-file-4.wav",
            "sample-file-5.png"
          )
        end
      end

      context "when path is not found" do
        let(:input_dir) { "does_not_exist" }

        it "returns success flag as false" do
          response = dir_reader.read

          expect(response[:success]).to eq(false)
        end

        it "returns empty list in data key" do
          response = dir_reader.read

          expect(response[:data]).to eq([])
        end
      end
    end
  end
end
