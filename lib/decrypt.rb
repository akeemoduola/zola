module Zola
  class Decryptor < Encryptor
    def get_key
      puts "Enter encryption key: "
      @key = gets.chomp
    end
    def get_date
      @date = File.ctime(input_file).strftime("%d%m%y").to_i
    end
    def cipher(rotation)
      characters =  [*'0'..'9', *'a'..'z',' ','.',","]
      rotated_characters = characters.rotate(rotation)
      Hash[rotated_characters.zip(characters)]
    end
  end
end
