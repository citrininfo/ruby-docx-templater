# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'template_processor_spec'

describe "integration test", :integration => true do
  #let(:data) { DocxTemplater::TestData::MOCK_DATA.call }
  #let(:input_file) { "#{base_path}/6.docx" }
  let(:data) { DocxTemplater::TestData::DATA }
  let(:input_file) { "#{base_path}/a4_templater.docx" }
  #let(:input_file) { "#{base_path}/3.docx" }
  let(:base_path) { SPEC_BASE_PATH.join("example_input") }
  #let(:input_file) { "#{base_path}/ExampleTemplate.docx" }
  let(:output_dir) { "#{base_path}/tmp" }
  let(:output_file) { "#{output_dir}/#{Time.now.to_i}.docx" }

  before do 
    FileUtils.rm_rf(output_dir) if File.exists?(output_dir)
    Dir.mkdir(output_dir)
  end

  context "should process in incoming docx" do
    it "generates a valid zip file (.docx)" do

      cached_images = {
        :image0 => DocxTemplater::Image.new('test1.jpeg', Base64.encode64(File.open("#{Dir.pwd}/spec/images/test1.png"){|f| f.read}), '450', '600'),
        :image2 => DocxTemplater::Image.new('test3.jpeg', Base64.encode64(File.open("#{Dir.pwd}/spec/images/test3.png"){|f| f.read}))
      }

      DocxTemplater::DocxCreator.new(input_file, data, cached_images, false).generate_docx_file(output_file)

      archive = ZipRuby::Archive.open(output_file)
      archive.close

      puts "\n************************************"
      puts "   >>> Only will work on mac <<<"
      puts "NOW attempting to open created file in Word."
      cmd = "open #{output_file}"
      puts "  will run '#{cmd}'"
      puts "************************************"

      system cmd
    end

    #it "generates a file with the same contents as the input docx" do
      #input_entries = ZipRuby::Archive.open(input_file) { |z| z.map(&:name) }
      #DocxTemplater::DocxCreator.new(input_file, data).generate_docx_file(output_file)
      #output_entries = ZipRuby::Archive.open(output_file) { |z| z.map(&:name) }

      #input_entries.should == output_entries
    #end
  end
end
