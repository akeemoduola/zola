require 'spec_helper'
require 'stringio'

# describe Zola do
#   it 'has a version number' do
#     expect(Zola::VERSION).not_to be nil
#   end
#
#   it 'does something useful' do
#     expect(false).to eq(true)
#   end
# end

module Zola
  describe Encryptor do
    before :all do
      File.open("test_message.txt", "w") {|f| f.write("hello, world..end..")}
     @e = Zola::Encryptor.new("test_message.txt", "encrypted.txt")
     @e.read_in_message
     @e.check_message
     @e.get_date
     srand(67809)
     @e.get_key
     @e.generate_keys
     @e.process_message
     @e.output_message
    end

    describe "#read_in_message" do
      it "reads message from input file" do
        expect(@e.instance_variable_get(:@message)).to eql("hello, world..end..")
      end
      before do
        @e1 = Zola::Encryptor.new("file_do_not_exist.txt", "encrypted.txt")
      end
      it "aborts execution if input file does not exist" do
        expect { @e1.read_in_message }.to raise_error(SystemExit)
      end
    end

    describe "#check_message" do
      before do
        File.open("test_message_2.txt", "w") {|f| f.write("Hello, World!..end..")}
        @e2 = Zola::Encryptor.new("test_message_2.txt", "encrypted.txt")
        @e2.read_in_message
      end
      it "checks if message has valid characters" do
        expect { @e2.check_message }.to raise_error(SystemExit)
      end
    end

    describe "#get_key" do
      it "returns a five digit random number as a String" do
        expect(@e.key).to eql("31774")
      end
    end

    before do
      @t = Time.now.strftime("%d%m%y").to_i
    end
    describe "#get_date" do
      it "returns the date message was sent in the format DDMMYY" do
        expect(@e.instance_variable_get(:@date)).to eql(@t)
      end
    end

    describe "#generate_keys" do
      it "returns an array- keys[] with four elements" do
        expect(@e.instance_variable_get(:@keys)).not_to be_empty
      end
      it "returns an array of size 4" do
        expect(@e.instance_variable_get(:@keys).size).to eql(4)
      end
    end

    before do
      @h = @e.cipher(13)
    end
    describe "#cipher(rotation)" do
      it "returns a hash" do
        expect(@h).to include("a"=>"n")
      end
    end

    describe "#process_letter(letter,rotation)" do
      it "returns 'letter' after rotating the character map by 'rotation' " do
        expect(@e.process_letter("a", 13)).to eql("n")
      end
    end

    describe "#process_message" do
      it "returns an encrypted message" do
        expect(@e.instance_variable_get(:@processed_message)).to eql("cxmmji.xj7mewhfo8h,")
      end
    end

  end

  describe Decryptor do
    before do
      @d = Zola::Decryptor.new("encrypted.txt", "decrypted.txt")
      @d.read_in_message
      $stdin = StringIO.new("31774")
    end
    after do
      $stdin = STDIN
    end

    describe "#get_key" do
      it "returns a five digit number as a String" do
        @d.get_key
        expect(@d.key).to eql("31774")
      end
    end

    before do
      @d.get_date
      @t = File.ctime("encrypted.txt").strftime("%d%m%y").to_i
    end
    describe "#get_date" do
      it "returns the date message was sent in the format DDMMYY" do
        expect(@d.instance_variable_get(:@date)).to eql(@t)
      end
    end
    before do
      @h = @d.cipher(13)
    end
    describe "#cipher(rotation)" do
      it "returns a hash" do
        expect(@h).to include(" " => "n")
      end
    end
  end

  describe Crack do
    before :all do
     @c = Zola::Crack.new("encrypted.txt", "cracked.txt")
     @c.read_in_message
     @c.get_date
     srand(67809)
     @c.get_key
     @c.generate_keys
     @c.process_message
     end
    before do
      @s = File.ctime("encrypted.txt").strftime("%d%m%y").to_i
    end
    describe "#get_date" do
      it "returns the date message was sent in the format DDMMYY" do
        expect(@c.instance_variable_get(:@date)).to eql(@s)
      end
    end

    before do
      @h = @c.cipher(13)
    end
    describe "#cipher(rotation)" do
      it "returns a hash" do
        expect(@h).to include(" " => "n")
      end
    end
      before do
        @c.crack_message
      end

    describe "#crack_message" do
      it "cracks the encrypted message" do
        expect(@c.instance_variable_get(:@processed_message)).to eql("hello, world..end..")
      end
    end
  end
end
