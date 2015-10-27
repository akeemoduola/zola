#!/usr/bin/env ruby
require "bundler/setup"
require "zola"

# quit unless our script gets two command line arguments
unless ARGV.length == 2
  puts "Dude, not the right number of arguments."
  puts "Usage: encrypt message.txt encrypted.txt"
  exit
end
input = ARGV[0]
output = ARGV[1]

e = Zola::Encryptor.new(input, output)
e.read_in_message
e.get_date
e.get_key
e.generate_keys
e.process_message
e.output_message