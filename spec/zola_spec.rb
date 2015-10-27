require 'spec_helper'

describe Zola do
  it 'has a version number' do
    expect(Zola::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end

module Spydec
  describe Website do
    before do
     @com_page = Spydec::Website.new("http://blog.com")
    end
      
    describe "#status" do
      it "returns the http status of the page" do
        expect(@com_page.status).to eql("200 OK")
      end
    end
    
    describe "#author" do
      it "returns the author metadata of the page" do
        expect(@com_page.author).to eql("Raymond Cudjoe")
      end
    end
    
    describe "#title" do
      it "returns the title metadata of the page" do
        expect(@com_page.title).to eql("Excel with Code")
      end
    end
    
    describe "#keywords" do
      it "returns an array of keywords metadata for the page" do
        expect(@com_page.keywords).to be_a(Array)
      end
    end
    
    describe "#desc" do
      it "returns the description metadata of the page" do
        expect(@com_page.desc).to eql("Become better at building
            products and selling them.")
      end
    end
    
    describe "#canonical" do
      it "returns the canonical metadata for the page" do
 	   expect(@com_page.canonical).to eql("http://blog.com")
      end
    end
    
    describe "#all" do
      it "returns an array of every metadata for the page" do
        expect(@com_page.all).to be_a(Array)
      end
      
      it "contains 5 elements" do
         expect(@com_page.all.count).to eql(5)
      end
      
      it "includes the title metadata" do
        expect(@com_page.all).to include(@com_page.title)
      end
      
      it "includes the canonical metadata" do
        expect(@com_page.all).to include(@com_page.canonical)
      end
      
      it "includes the page description metadata" do
        expect(@com_page.all).to include(@com_page.desc)
      end
      
      it "includes the page author's name metadata" do
        expect(@com_page.all).to include(@com_page.author)
      end
      
      it "includes the keywords metadata" do
        expect(@com_page.all).to include(@com_page.keywords)
      end
    end
    
  end
end
