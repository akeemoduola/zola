require 'zola_spec'
module Zola
  describe Encryptor do
    before :all do
      File.open("message.txt", "w") {|f| f.write("hello, world..end..")}
     @e = Zola::Encryptor.new("message.txt", "encrypted.txt")
     srand(67809)
     @e.execute
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
        expect(@e.key).to eql("21774")
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
        expect(@e.instance_variable_get(:@processed_message)).to eql("2xmm9i.x97memhfo.h,")
      end
    end
  end
end
