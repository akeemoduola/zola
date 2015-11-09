module Zola
  class Encryptor
    attr_accessor :input_file, :output_file, :message, :key, :date,:keys, :processed_message

    def initialize(input_file, output_file)
      @input_file = input_file
      @output_file = output_file
      @message = ""
      @processed_message = ""
      @key = ""
      @date = 0
      @keys = []
      @characters =  [*'0'..'9', *'a'..'z',' ','.',","]
    end

    def get_key
      @key = 5.times.map { Random.rand(9) }.join
    end

    def get_date
      @date = Time.now.strftime("%d%m%y").to_i
    end

    def generate_keys
      key = generate_key
      offset = generate_offset
      @keys << key[0] + offset[0]
      @keys << key[1] + offset[1]
      @keys << key[2] + offset[2]
      @keys << key[3] + offset[3]
      @keys
    end
    def generate_key
      key = []
      key << @key[0..1].to_i
      key << @key[1..2].to_i
      key << @key[2..3].to_i
      key << @key[3..4].to_i
      key
    end
    def generate_offset
      (@date ** 2).to_s.split(//).map(&:to_i).last(4)
    end
    def cipher(rotation)
      rotated_characters = @characters.rotate(rotation)
      Hash[@characters.zip(rotated_characters)]
    end

    def process_letter(letter,rotation)
      cipher_for_rotation = cipher(rotation)
      cipher_for_rotation[letter]
    end

    def read_in_message
      if File.exist?(@input_file)
        @message = File.open(@input_file, "r") { |f| f.read}
      else
        Kernel.abort("ABORTED! File: #{@input_file} Not Found in current directory")
      end
    end

    def check_message
      @message.downcase!
      pattern = /[^a-z0-9 ,.]/
      if !(@message =~ pattern).nil?
        Kernel.abort("ABORTED! Invalid character(s) in message")
      end
    end

    def process_message
      count = 0
      strlen = @message.length
      for i in 0...strlen do
        @processed_message += process_letter(@message[i], @keys[count])
        count +=1
        if count == 4
          count = 0
        end
      end
      @processed_message
    end
    def execute
      read_in_message
      check_message
      get_date
      get_key
      generate_keys
      process_message
      output_message
    end
    def output_message
      File.open(@output_file, "w") { |f| f.write(@processed_message)}
      puts "Created #{@output_file} with the key #{@key} and date #{@date}"
    end
  end
end
