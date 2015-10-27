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
        @processed_message = ""
        get_key
        generate_keys
        process_message
      end
      output_message
    end
    def output_message
      File.open(@output_file, "w") { |f| f.write(@processed_message)}
      puts "Created #{@output_file} with the cracked #{@key} and #{@date}"
    end
  end
end
