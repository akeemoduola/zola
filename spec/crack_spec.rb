require 'zola_spec'
module Zola
  describe Crack do
    before :all do
      File.open("test_message_1.txt", "w") {|f| f.write("hello, world..end..")}
      Zola::Encryptor.new("test_message_1.txt", "encrypted_1.txt").execute
      @c = Zola::Crack.new("encrypted_1.txt", "cracked.txt")
      @c.read_in_message
     end
    before do
      @h = @c.cipher(13)
    end
    describe "#cipher(rotation)" do
      it "returns a hash" do
        expect(@h).to include(" " => "n")
      end
    end
    describe "#get_cipher_rotations" do
      it "returns the cipher rotations array" do
        expect((@c.get_cipher_rotations).length).to eql(4)
      end
    end
    describe "#get_indexes" do
      it "returns an array of indexes of characters in a string from the character map" do
        expect(@c.get_indexes('..end..')).to include(37)
      end
    end
    describe "#get_rotations" do
      it "returns number of rotations between encrypted and unencrypted letters" do
        expect(@c.get_rotations([37,37,14,23,13,37,37],[38,37,1,19,14,37,24])).to include(4)
      end
    end
    describe "#reverse_rotations" do
      it "maps encrypted letter index to its unencrypted letter" do
        expect(@c.reverse_rotations([4,38,0,13])).to include(35)
      end
    end
  end
end
