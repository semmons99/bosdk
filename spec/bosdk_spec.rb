# encoding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'bosdk'

module BOSDK
  describe BOSDK do
    describe "#connect" do
      specify "wraps EnterpriseSession#new in a closure" do
        es = mock("EnterpriseSession").as_null_object
        class EnterpriseSession; end
        EnterpriseSession.should_receive(:new).once.with('cms', 'Administrator', '', {:locale => "en_US"}).and_return(es)
        es.should_receive(:disconnect).once.with.and_return

        BOSDK.connect('cms', 'Administrator', '', :locale => "en_US") do |session|
          session.should == es
        end
      end
    end
  end
end
