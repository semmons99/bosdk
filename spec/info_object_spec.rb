# encoding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'bosdk/info_object'

module BOSDK
  describe InfoObject do
    before(:each) do
      # mocks
      @infoobject = mock("IInfoObject").as_null_object

      @obj = InfoObject.new(@infoobject)
    end
    
    describe "#docid" do
      it "should call #getID and return the result" do
        @infoobject.should_receive(:getID).once.with.and_return(1)

        @obj.docid.should == 1
      end

      it "should only call #getID once" do
        @infoobject.should_receive(:getID).once.with.and_return(1)

        2.times{@obj.docid.should == 1}
      end
    end

    describe "#is_root?" do
      it "should return true when #parent_id is nil" do
        @infoobject.should_receive(:parent_id).once.with.and_return(nil)

        @obj.is_root?.should be_true
      end

      it "should return true when #parent_id is '0'" do
        @infoobject.should_receive(:parent_id).once.with.and_return(0)

        @obj.is_root?.should be_true
      end

      it "should return true when #parent_id == #getID" do
        @infoobject.should_receive(:parent_id).once.with.and_return(1)
        @infoobject.should_receive(:getID).once.with.and_return(1)

        @obj.is_root?.should be_true
      end

      it "should return false when #parent_id is not: nil, '0' or #getID" do
        @infoobject.should_receive(:parent_id).once.with.and_return(1)
        @infoobject.should_receive(:getID).once.with.and_return(2)

        @obj.is_root?.should be_false
      end
    end

    describe "#parent" do
      it "should return nil if #is_root? == true" do
        @infoobject.should_receive(:parent_id).once.with.and_return(nil)

        @obj.parent.should be_nil
      end

      it "should return results of #getParent if #is_root? == false" do
        parent_obj = mock("IInfoObject").as_null_object
        @infoobject.should_receive(:parent_id).once.with.and_return(1)
        @infoobject.should_receive(:getID).once.with.and_return(2)
        @infoobject.should_receive(:getParent).once.with.and_return(parent_obj)

        parent = @obj.parent
        parent.should be_instance_of InfoObject
        parent.obj.should == parent_obj
      end

      it "should only call the underlying #getParent once" do
        parent_obj = mock("IInfoObject").as_null_object
        @infoobject.should_receive(:parent_id).once.with.and_return(1)
        @infoobject.should_receive(:getID).once.with.and_return(2)
        @infoobject.should_receive(:getParent).once.with.and_return(parent_obj)

        2.times{@obj.parent}
      end
    end

    describe "#path" do
      it "should return /#title if #is_root? == true" do
        @infoobject.should_receive(:parent_id).once.with.and_return(nil)
        @infoobject.should_receive(:title).once.with.and_return('test obj')

        @obj.path.should == '/test obj'
      end

      it "should return #parent_title/../#title if #is_root? == false" do
        parent_obj = mock("IInfoObject").as_null_object
        parent_obj.should_receive(:parent_id).once.with.and_return(nil)
        parent_obj.should_receive(:title).once.with.and_return('test parent')

        @infoobject.should_receive(:parent_id).once.with.and_return(1)
        @infoobject.should_receive(:getID).once.with.and_return(2)
        @infoobject.should_receive(:title).once.with.and_return('test obj')
        @infoobject.should_receive(:getParent).once.with.and_return(parent_obj)

        @obj.path.should == '/test parent/test obj'
      end

      it "should only call the underlying #title, #parent#path, etc. once" do
        parent_obj = mock("IInfoObject").as_null_object
        parent_obj.should_receive(:parent_id).once.with.and_return(nil)
        parent_obj.should_receive(:title).once.with.and_return('test parent')

        @infoobject.should_receive(:parent_id).once.with.and_return(1)
        @infoobject.should_receive(:getID).once.with.and_return(2)
        @infoobject.should_receive(:title).once.with.and_return('test obj')
        @infoobject.should_receive(:getParent).once.with.and_return(parent_obj)

        2.times{@obj.path}
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
