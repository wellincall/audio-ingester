# frozen_string_literal: true

class DirReader
  def initialize(input_path)
    @input_path = input_path
  end

  def read
    return invalid_response if unknown_folder?

    all_entries = Dir.children(input_path)
    files = all_entries.select do |file| 
      File.file?(File.join(input_path, file))
    end
    { success: true, data: files }
  end

  private

  attr_reader :input_path

  def unknown_folder?
    !Dir.exist?(input_path)
  end

  def invalid_response
    { success: false, data: [] }
  end

end
