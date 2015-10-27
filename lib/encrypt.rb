module Zola
  class Encryptor
    attr_accessor :input_file, :output_file, :message, :key, :date,
                  :keys, :processed_message

    def initialize(input_file, output_file)
      @input_file = input_file
      @output_file = output_file
      @message = ""
      @processed_message = ""
      @key = ""
      @date = 0
      @keys = []
    end

    def get_key
      @key = (0...5).map { |i| rand((i == 0? 1 : 0)..9)}.join
    end

    def get_date
      @date = Time.now.strftime("%d%m%y").to_i
    end

    def generate_keys
       a_key = @key[0..1].to_i
       b_key = @key[1..2].to_i
       c_key = @key[2..3].to_i
       d_key = @key[3..4].to_i

       offset = (@date ** 2).to_s[-4..-1]
       a_offset = offset[0].to_i
       b_offset = offset[1].to_i
       c_offset = offset[2].to_i
       d_offset = offset[3].to_i

       a_rotation = a_key + a_offset
       b_rotation = b_key + b_offset
       c_rotation = c_key + c_offset
       d_rotation = d_key + d_offset

       @keys = [a_rotation , b_rotation, c_rotation, d_rotation]
    end

    def cipher(rotation)
      characters =  [*'0'..'9', *'a'..'z',' ','.',","]
      rotated_characters = characters.rotate(rotation)
      Hash[characters.zip(rotated_characters)]
    end

    def process_letter(letter,rotation)
      cipher_for_rotation = cipher(rotation)
      cipher_for_rotation[letter]
    end

    def read_in_message
      @message = File.open(@input_file, "r") { |f| f.read}
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

    def output_message
      File.open(@output_file, "w") { |f| f.write(@processed_message)}
      puts "Created #{@output_file} with #{@key} and #{@date}"
    end
  end
end
