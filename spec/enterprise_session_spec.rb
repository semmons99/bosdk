# encoding: utf-8
include Java
Dir.glob(ENV["BOE_JAVA_LIB"] + "/*.jar").each {|jar| require jar}
include_class "com.crystaldecisions.sdk.framework.CrystalEnterprise"

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'bosdk/enterprise_session'

module BOSDK
  describe EnterpriseSession do
    before(:each) do
      # mocks
      @session_mgr = mock("ISessionMgr").as_null_object
      @session = mock("IEnterpriseSession").as_null_object

      # stubs
      CrystalEnterprise.should_receive(:getSessionMgr).with.and_return(@session_mgr)
      @session_mgr.should_receive(:logon).once.with('Administrator', '', 'cms', 'secEnterprise').and_return(@session)
      @session.should_receive(:logoff).at_most(2).with.and_return

      @es = EnterpriseSession.new('cms', 'Administrator', '')
    end

    specify "#connected? returns 'true' when connected to a CMS" do
      @es.connected?.should be_true
    end

    specify "#connected? returns 'false' when not connected to a CMS" do
      @es.disconnect
      @es.connected?.should be_false
    end

    specify "#disconnect should disconnect from the CMS" do
      @es.disconnect
      @es.connected?.should be_false
    end

    specify "#disconnect shouldn't raise an error when not connected" do
      @es.disconnect
      lambda{@es.disconnect}.should_not raise_exception
    end
  end
end
