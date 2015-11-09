module Zola
  class Crack < Encryptor
    attr_accessor :known, :char_hash
    def initialize(input_file, output_file)
      @known = "..end.."
      @characters =  [*'0'..'9', *'a'..'z',' ','.',","]
      @date = 0
      @number_of_ciphers = 4
      @char_hash = Hash[@characters.map.with_index { |char, i| [char, i] }]
      super(input_file, output_file)
    end
    def execute
      read_in_message
      get_cipher_rotations
      process_message
      output_message
    end
    def get_cipher_rotations
      # get the index positions of the known keywords letters, and corresponding encrypted keywords letters
      known_indexes = get_indexes(@known)
      encrypted_part = @message[-@known.length, @known.length]
      encrypted_indexes = get_indexes(encrypted_part)
      # subtract the paired indexes to get the number of rotations between the encrypted and unencrypted letters
      rotations = get_rotations(known_indexes, encrypted_indexes)

      # reverse the rotations so that the encrypted letter points to its unencrypted letter
      inverted_rotations = reverse_rotations(rotations)

      # figure out what position each cipher is using
      r = -@message.length % @number_of_ciphers
      @keys = inverted_rotations.rotate(r)
    end

    def cipher(rotation)
      rotated_characters = @characters.rotate(rotation)
      Hash[rotated_characters.zip(@characters)]
    end

    def get_indexes(message)
      message.each_char.map do |char|
        @char_hash[char]
      end
    end

    def get_rotations(known , encrypted)
      rotations = known.zip(encrypted).map do |i|
                    difference = i[0] - i[1]
                    # if it takes negative rotations, get the positive counter rotations
                    difference = @characters.length + difference if difference < 0
                    difference
      end
      rotations.flatten.last(4)
    end

    def reverse_rotations(rotations)
      len = @characters.length
      rotations.map{ |number| len - number }
    end
    def output_message
      File.open(@output_file, "w") { |f| f.write(@processed_message)}
      puts "Created #{@output_file} with ciphers #{@keys}"
    end
  end
end
