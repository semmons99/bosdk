$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'bosdk/webi_instance'

module BOSDK
  describe WebiInstance do
    before(:each) do
      @document_instance = mock("DocumentInstance").as_null_object

      @webi = WebiInstance.new(@document_instance)
    end

    describe "#new" do
      it "should store the passed DocumentInstance in @doc_instance" do
        @webi.instance.should == @document_instance
      end
    end
  end
end
