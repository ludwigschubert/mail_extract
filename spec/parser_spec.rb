require 'spec_helper'

describe 'MailExtract::Parser' do
  it 'parses an email' do
    parser = parser_for_fixture('simple.txt')
    parser.body.should == result_fixture('simple.txt')
    parser.quote.should == ''
  end

  it 'parses an email with quotes' do
    parser = parser_for_fixture('simple_with_quotes.txt')
    parser.body.should == result_fixture('simple_with_quotes.txt')
    parser.quote.should == quote_fixture('simple_with_quotes.txt')
  end

  it 'parses a reply email with broken authored line' do
    parser = parser_for_fixture('reply_with_quotes.txt')
    parser.body.should == 'This is a first line of the message'
    parser.quote.should == quote_fixture('reply_with_quotes.txt')
  end

  it 'parses a message send via iphone' do
    parser = parser_for_fixture('iphone.txt')
    parser.body.should == 'This is a shit i sent from my iphone'
  end

  it 'parses a reply sent via iphone' do
    parser = MailExtract.new(fixture('iphone_with_quotes.txt'), :only_head => true)
    parser.body.should == 'Primary reply content'
  end
end
