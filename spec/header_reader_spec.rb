# frozen_string_literal: true

require "header_reader"

RSpec.describe HeaderReader do
  let(:file_path) { "input_files/sample-file-3.wav" }

  let(:reader) { described_class.new(file_path) }

  describe "#read" do
    it "returns a hash" do
      response = reader.read

      expect(response).to be_an_instance_of(Hash)
    end

    describe "hash response" do
      it "returns success flag as true" do
        response = reader.read

        expect(response[:success]).to eq(true)
      end
      
      it "returns .wav header in data key" do
        response = reader.read

        file = File.new(file_path)
        file_header = file.read(44)
        file.close

        expect(response[:data]).to eq(file_header)
      end

      context "when file is not .wav" do
        let(:file_path) { "input_files/sample-file-1.txt" }

        it "returns success flag as false" do
          response = reader.read

          expect(response[:success]).to eq(false)
        end

        it "returns empty string in data key" do
          response = reader.read

          expect(response[:data]).to eq("")
        end
      end

      context "when file does not exist" do
        let(:file_path) { "input_files/non-existing.wav" }

        it "returns success flag as false" do
          response = reader.read

          expect(response[:success]).to eq(false)
        end

        it "returns empty string in data key" do
          response = reader.read

          expect(response[:data]).to eq("")
        end
      end
    end
  end
end
