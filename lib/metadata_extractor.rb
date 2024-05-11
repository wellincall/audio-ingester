# frozen_string_literal: true

class MetadataExtractor
  def initialize(metadata_bytes)
    @metadata_bytes = metadata_bytes
  end

  def extract
    return invalid_response if invalid_metadata_length?
    
    metadata = values_from_bytes
    response_metadata = add_bit_rate(metadata)
    { success: true, data: response_metadata }
  end

  private

  attr_reader :metadata_bytes

  def invalid_metadata_length?
    metadata_bytes.length != 44
  end

  def invalid_response
    { success: false, data: {} }
  end

  def values_from_bytes
    {
      format: extract_data(20, 2),
      channel_count: extract_data(22, 2),
      sampling_rate: extract_data(24, 4),
      byte_rate: extract_data(28, 4),
      bit_depth: extract_data(34, 2)
    }
  end

  def add_bit_rate(metadata)
    bit_rate = metadata[:sampling_rate] * metadata[:channel_count] * metadata[:bit_depth]
    metadata.merge(bit_rate: bit_rate)
  end

  def extract_data(position, size)
    unpacking = size == 4 ? "V" : "v"
    metadata_bytes[position...(position + size)].unpack(unpacking)[0]
  end
end
