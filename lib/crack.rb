module Zola
  class Crack < Encryptor
    def get_date
      @date = File.ctime(input_file).strftime("%d%m%y").to_i
    end

    def cipher(rotation)
      characters =  [*'0'..'9', *'a'..'z',' ','.',","]
      rotated_characters = characters.rotate(rotation)
      Hash[rotated_characters.zip(characters)]
    end
    def crack_message
      while  @processed_message[-7..-1] != "..end.." do
        get_key
        generate_keys
        process_message
      end
      output_message
    end
  end
end
