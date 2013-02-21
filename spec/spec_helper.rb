$:.unshift File.expand_path("../..", __FILE__)

require 'mail_extract'

def fixture_path(file=nil)
  path = File.expand_path("../fixtures", __FILE__)
  path = File.join(path, file) unless file.nil?
  path
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end

def result_fixture(file)
  fixture("result_#{file}")
end

def quote_fixture(file)
  fixture("quote_#{file}")
end

def parse_fixture(file)
  parser_for_fixture(file).body
end

def parser_for_fixture(file)
  MailExtract.new(fixture(file))
end
