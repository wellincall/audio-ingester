# frozen_string_literal: true

require "metadata_extractor"

RSpec.describe MetadataExtractor do
  let(:input_file) { File.new("input_files/sample-file-3.wav") }
  let(:metadata) do
    input_file.read(44)
  end

  let(:extractor) { described_class.new(metadata) }

  describe "#extract" do
    it "returns a hash" do
      response = extractor.extract

      expect(response).to be_an_instance_of(Hash)
    end

    describe "response hash" do
      it "returns success flag as true" do
        response = extractor.extract

        expect(response[:success]).to eq(true)
      end

      it "returns metadata contract in data key" do
        response = extractor.extract

        expect(response[:data]).to eq({
          format: 1,
          channel_count: 2,
          sampling_rate: 44100,
          byte_rate: 176400,
          bit_depth: 16,
          bit_rate: 1411200
        })
      end
    end

    context "when metadata does not match expected pattern" do
      let(:metadata) { "" }

      it "returns success flag as false" do
        response = extractor.extract

        expect(response[:success]).to eq(false)
      end

      it "returns empty metadata contract in data key" do
        response = extractor.extract

        expect(response[:data]).to eq({})
      end
    end
  end

end
