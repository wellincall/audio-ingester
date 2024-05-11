# frozen_string_literal: true

require "nokogiri"
require "metadata_xml_builder"

RSpec.describe MetadataXmlBuilder do
  let(:input) do
    {
      format: 1,
      channel_count: 34,
      sampling_rate: 50000,
      byte_rate: 100000,
      bit_depth: 55,
      bit_rate: 30
    }
  end

  let(:xml_builder) { MetadataXmlBuilder.new(input) }

  describe "#build" do
    it "returns a string" do
      response = xml_builder.build

      expect(response).to be_an_instance_of(String)
    end

    describe "string response" do
      it "contains the XML response for the given input" do
        response = xml_builder.build

        expect(response).to eq(
          <<~METADATA_XML
          <?xml version="1.0"?>
          <wavFile>
            <format>PCM</format>
            <channelCount>34</channelCount>
            <samplingRate>50000</samplingRate>
            <byteRate>100000</byteRate>
            <bitDepth>55</bitDepth>
            <bitRate>30</bitRate>
          </wavFile>
          METADATA_XML
          
        )
      end

      context "when expected field is missing" do
        let(:input) do
          {
            format: 1,
            sampling_rate: 50000,
            byte_rate: 100000,
            bit_depth: 55,
            bit_rate: 30
          }
        end

        it "adds NA in the corresponding key" do
          response = xml_builder.build

          expect(response).to eq(
            <<~METADATA_XML
            <?xml version="1.0"?>
            <wavFile>
              <format>PCM</format>
              <channelCount>NA</channelCount>
              <samplingRate>50000</samplingRate>
              <byteRate>100000</byteRate>
              <bitDepth>55</bitDepth>
              <bitRate>30</bitRate>
            </wavFile>
            METADATA_XML
          )
        end
      end

      

      describe "format node" do
        it "returns PCM" do
          response = xml_builder.build
          parsed_response = Nokogiri::XML(response)
          node = parsed_response.xpath("wavFile/format")

          expect(node.text).to eq("PCM")
        end

        context "when value is anything else" do
          let(:input) do
            {
              format: 23,
              channel_count: 34,
              sampling_rate: 50000,
              byte_rate: 100000,
              bit_depth: 55,
              bit_rate: 30
            }
          end

          it "returns Compressed" do
            response = xml_builder.build
            parsed_response = Nokogiri::XML(response)
            node = parsed_response.xpath("wavFile/format")

            expect(node.text).to eq("Compressed")
          end
        end
      end
    end
  end
end
