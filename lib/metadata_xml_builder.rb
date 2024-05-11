# frozen_string_literal: true
require "pry"

class MetadataXmlBuilder
  def initialize(metadata)
    @metadata = metadata.slice(*allowed_keys)
  end

  def build
    xml_builder = Nokogiri::XML::Builder.new do |xml|
      xml.wavFile do
        xml.format format_in_xml(metadata[:format])
        xml.channelCount metadata.fetch(:channel_count, "NA")
        xml.samplingRate metadata.fetch(:sampling_rate, "NA")
        xml.byteRate metadata.fetch(:byte_rate, "NA")
        xml.bitDepth metadata.fetch(:bit_depth, "NA")
        xml.bitRate metadata.fetch(:bit_rate, "NA")
      end
    end
    xml_builder.to_xml
  end

  private

  attr_reader :metadata

  def allowed_keys
    %i[format channel_count sampling_rate byte_rate bit_depth bit_rate]
  end

  def format_in_xml(format)
    return "NA" if format.nil?

    format == 1 ? "PCM" : "Compressed"
  end
end
