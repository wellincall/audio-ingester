# frozen_string_literal: true

require_relative "lib/dir_reader"
require_relative "lib/header_reader"
require_relative "lib/metadata_extractor"
require_relative "lib/metadata_xml_builder"
require "fileutils"

input_dir = ARGV[0]

dir_reader_response = DirReader.new(input_dir).read

if !dir_reader_response[:success]
  puts "input directory not found"

  return
end

processing_started_at = Time.now.to_i

file_paths = dir_reader_response[:data].map {|file| File.join(input_dir, file)}

file_headers = file_paths.map do |file_path|
  HeaderReader.new(file_path).read.merge(file_name: file_path)
end

metadata_files = file_headers.map do |file_headers|
  if file_headers[:success]
    extractor = MetadataExtractor.new(file_headers[:data])
    extractor.extract.merge(file_name: file_headers[:file_name])
  else
    puts "#{file_headers[:file_name]} didn't have its headers processed"

    { file_name: file_headers[:file_name] }
  end
end

xmls = metadata_files.map do |metadata|
  if metadata[:success]
    xml_builder = MetadataXmlBuilder.new(metadata[:data])
    { file_name: metadata[:file_name], content: xml_builder.build }
  else
    puts "#{metadata[:file_name]} didn't have its metadata extracted"
    {}
  end
end

output_folder = "output/#{processing_started_at}"

FileUtils.mkdir_p(output_folder)

xmls.each do |xml_content|
  next if xml_content[:content].nil?

  file_name = File.basename(xml_content[:file_name], ".*")
  File.open(File.join(output_folder, "#{file_name}.xml"), "w") do |f|
    f.write(xml_content[:content])
  end
  puts "XML file created in #{File.join(output_folder, "#{file_name}.xml")}"
end
