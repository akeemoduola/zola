require 'zola_spec'
module Zola
  describe Decryptor do
    before do
      @d = Zola::Decryptor.new("encrypted_1.txt", "decrypted.txt")
      @d.read_in_message
      $stdin = StringIO.new("21774")
    end
    after do
      $stdin = STDIN
    end

    describe "#get_key" do
      it "returns a five digit number as a String" do
        @d.get_key
        expect(@d.key).to eql("21774")
      end
    end

    before do
      @d.get_date
      @t = File.ctime("encrypted_1.txt").strftime("%d%m%y").to_i
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
end
