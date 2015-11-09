module Zola
  class Decryptor < Encryptor
    def get_key
      print "Enter encryption key: "
      @key = $stdin.gets.chomp
    end
    def get_date
      @date = File.ctime(input_file).strftime("%d%m%y").to_i
    end
    def cipher(rotation)
      rotated_characters = @characters.rotate(rotation)
      Hash[rotated_characters.zip(@characters)]
    end
    def execute
      read_in_message
      get_key
      get_date
      generate_keys
      process_message
      output_message
    end
  end
end
