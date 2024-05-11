# frozen_string_literal: true

class HeaderReader
  def initialize(file_path)
    @file_path = file_path
  end

  def read
    return invalid_response if file_not_found?
    return invalid_response if not_wav_file?

    { success: true, data: file_header }
  end

  private

  attr_reader :file_path

  def invalid_response
    { success: false, data: "" }
  end

  def file_not_found?
    !File.file?(file_path)
  end

  def not_wav_file?
    File.extname(file_path) != ".wav"
  end

  def file_header
    file = File.new(file_path)
    header = file.read(44)
    file.close

    header
  end
end
