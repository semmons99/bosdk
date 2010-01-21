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
      @infostore = mock("IInfoStore").as_null_object
      @infoobjects = mock("IInfoObjects").as_null_object

      # stubs
      CrystalEnterprise.should_receive(:getSessionMgr).and_return(@session_mgr)
      @session_mgr.should_receive(:logon).once.with('Administrator', '', 'cms', 'secEnterprise').and_return(@session)
      @session.should_receive(:getService).once.with('', 'InfoStore').and_return(@infostore)

      @es = EnterpriseSession.new('cms', 'Administrator', '')
    end

    specify "#connected? returns 'true' when connected to a CMS" do
      @es.connected?.should be_true
    end

    specify "#connected? returns 'false' when not connected to a CMS" do
      @session.should_receive(:logoff).once.with.and_return

      @es.disconnect
      @es.connected?.should be_false
    end

    specify "#disconnect should disconnect from the CMS" do
      @session.should_receive(:logoff).once.with.and_return

      @es.disconnect
      @es.connected?.should be_false
    end

    specify "#disconnect shouldn't raise an error when not connected" do
      @session.should_receive(:logoff).once.with.and_return

      lambda{2.times{ @es.disconnect }}.should_not raise_exception
    end

    specify "#query should send the statement to the underlying InfoStore" do
      stmt = 'SELECT * FROM CI_infoobjectS'
      @infostore.should_receive(:query).once.with(stmt).and_return([])

      @es.query(stmt)
    end
  end
end
