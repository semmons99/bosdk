$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'bosdk/info_object'

module BOSDK
  describe InfoObject do
    before(:each) do
      @infoobject = mock("IInfoObject").as_null_object

      @obj = InfoObject.new(@infoobject)
    end
    
    describe "#docid" do
      before(:each) do
        @infoobject.should_receive(:getID).once.with.and_return(1)
      end

      it "should call #getID and return the result" do
        @obj.docid.should == 1
      end

      it "should only call #getID once" do
        2.times{@obj.docid.should == 1}
      end
    end

    describe "#is_root?" do
      context "when #parent_id == nil" do
        before(:each) do
          @infoobject.should_receive(:parent_id).once.with.and_return(nil)
        end

        it "should return true" do
          @obj.is_root?.should be_true
        end
      end

      context "when #parent_id == 0" do
        before(:each) do
          @infoobject.should_receive(:parent_id).once.with.and_return(0)
        end

        it "should return true" do
          @obj.is_root?.should be_true
        end
      end

      context "when #parent_id == #getID" do
        before(:each) do
          @infoobject.should_receive(:parent_id).once.with.and_return(1)
          @infoobject.should_receive(:getID).once.with.and_return(1)
        end

        it "should return true" do
          @obj.is_root?.should be_true
        end
      end

      context "when #parent_id != nil, 0 or #getID" do
        before(:each) do
          @infoobject.should_receive(:parent_id).once.with.and_return(1)
          @infoobject.should_receive(:getID).once.with.and_return(2)
        end

        it "should return false" do
          @obj.is_root?.should be_false
        end
      end
    end

    describe "#parent" do
      context "when #is_root? == true" do
        before(:each) do
          @infoobject.should_receive(:parent_id).once.with.and_return(nil)
        end

        it "should return nil" do
          @obj.parent.should be_nil
        end
      end

      context "when #is_root? == false" do
        before(:each) do
          @parent_obj = mock("IInfoObject").as_null_object
          @infoobject.should_receive(:parent_id).once.with.and_return(1)
          @infoobject.should_receive(:getID).once.with.and_return(2)
          @infoobject.should_receive(:getParent).once.with.and_return(@parent_obj)
        end

        it "should return results of #getParent" do
          parent = @obj.parent
          parent.should be_instance_of InfoObject
          parent.obj.should == @parent_obj
        end

        it "should only call the underlying #getParent once" do
          2.times{@obj.parent}
        end
      end
    end

    describe "#path" do
      context "when #is_root? == true" do
        before(:each) do
          @infoobject.should_receive(:parent_id).once.with.and_return(nil)
          @infoobject.should_receive(:title).once.with.and_return('test obj')
        end

        it "should return /#title" do
          @obj.path.should == '/test obj'
        end
      end

      context "when #is_root? == false" do
        before(:each) do
          @parent_obj = mock("IInfoObject").as_null_object
          @parent_obj.should_receive(:parent_id).once.with.and_return(nil)
          @parent_obj.should_receive(:title).once.with.and_return('test parent')

          @infoobject.should_receive(:parent_id).once.with.and_return(1)
          @infoobject.should_receive(:getID).once.with.and_return(2)
          @infoobject.should_receive(:title).once.with.and_return('test obj')
          @infoobject.should_receive(:getParent).once.with.and_return(@parent_obj)
        end

        it "should return #parent_title/../#title" do
          @obj.path.should == '/test parent/test obj'
        end

        it "should only call the underlying #title, #parent#path, etc. once" do
          2.times{@obj.path}
        end
      end
    end

    describe "#<=>" do
      it "should use #title" do
        objs = []
        ('a'..'c').to_a.reverse.each do |ltr|
          obj = mock("IInfoObject").as_null_object
          obj.should_receive(:title).once.with.and_return(ltr)
          objs << InfoObject.new(obj)
        end

        sorted_objs = objs.sort
        sorted_objs.should == objs.reverse
      end
    end
  end
end
