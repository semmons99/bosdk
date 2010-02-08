$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'bosdk/enterprise_session'

module BOSDK
  describe EnterpriseSession do
    before(:each) do
      @session_mgr = mock("ISessionMgr").as_null_object
      @session = mock("IEnterpriseSession").as_null_object
      @infostore = mock("IInfoStore").as_null_object
      @infoobjects = mock("IInfoObjects").as_null_object

      class CrystalEnterprise; end
      CrystalEnterprise.should_receive(:getSessionMgr).at_least(1).with.and_return(@session_mgr)
      @session_mgr.should_receive(:logon).at_least(1).with('Administrator', '', 'cms', 'secEnterprise').and_return(@session)
      @session.should_receive(:getService).at_least(1).with('', 'InfoStore').and_return(@infostore)

      @es = EnterpriseSession.new('cms', 'Administrator', '')
    end

    describe "#new" do
      it "should accept an optional locale setting" do
        EnterpriseSession.new('cms', 'Administrator', '', :locale => 'en_CA')
      end
    end

    describe "#connected?" do
      before(:each) do
        @session.should_receive(:logoff).at_most(1).with.and_return
      end

      it "returns 'true' when connected to a CMS" do
        @es.connected?.should be_true
      end

      it "returns 'false' when not connected to a CMS" do
        @es.disconnect
        @es.connected?.should be_false
      end
    end

    describe "#disconnect" do
      before(:each) do
        @session.should_receive(:logoff).once.with.and_return
      end

      it "should disconnect from the CMS" do
        @es.disconnect
        @es.connected?.should be_false
      end

      it "shouldn't raise an error when not connected" do
        lambda{2.times{ @es.disconnect }}.should_not raise_exception
      end
    end

    describe "#path_to_sql" do
      before(:each) do
        @path_query = 'path://SystemObjects/Users/Administrator@SI_ID'
        @stmt = "SELECT SI_ID FROM CI_SYSTEMOBJECTS WHERE SI_KIND='User' AND SI_NAME='Administrator'"
        
        @stateless_page_info = mock("IStatelessPageInfo").as_null_object

        class PagingQueryOptions; end
        PagingQueryOptions.should_receive(:new).once.with
        @infostore.should_receive(:getStatelessPageInfo).once.with(@path_query, nil).and_return(@stateless_page_info)
        @stateless_page_info.should_receive(:getPageSQL).once.with.and_return(@stmt)
      end

      it "should convert a path query to an sql query" do
        @es.path_to_sql(@path_query).should == @stmt
      end
    end

    describe "#query" do
      context "when :type => sql" do
        before(:each) do
          @stmt = 'SELECT * FROM CI_INFOOBJECTS'
          @infostore.should_receive(:query).once.with(@stmt).and_return([])
        end

        it "should send the statement to the underlying InfoStore" do
          @es.query(@stmt)
        end
      end

      context "when :type => path://" do
        before(:each) do
          @path_query = 'path://SystemObjects/Users/Administrator@SI_ID'
          @stmt = "SELECT * FROM CI_SYSTEMOBJECTS WHERE SI_KIND='User' AND SI_NAME='Administator'"

          @es.should_receive(:path_to_sql).once.with(@path_query).and_return(@stmt)
          @infostore.should_receive(:query).once.with(@stmt).and_return([])
        end

        it "should convert a path:// query to sql before execution" do
          @es.query(@path_query)
        end
      end

      context "when :type => query://" do
        before(:each) do
          @path_query = 'query://{SELECT * FROM CI_INFOOBJECTS}'
          @stmt = 'SELECT * FROM CI_INFOOBJECTS'

          @es.should_receive(:path_to_sql).once.with(@path_query).and_return(@stmt)
          @infostore.should_receive(:query).once.with(@stmt).and_return([])
        end

        it "should convert a query:// query to sql before execution" do
          @es.query(@path_query)
        end
      end

      context "when :type => cuid://" do
        before(:each) do
          @path_query = 'cuid://ABC'
          @stmt = "SELECT * FROM CI_INFOOBJECTS WHERE SI_CUID='ABC'"

          @es.should_receive(:path_to_sql).once.with(@path_query).and_return(@stmt)
          @infostore.should_receive(:query).once.with(@stmt).and_return([])
        end

        it "should convert a cuid:// query to sql before execution" do
          @es.query(@path_query)
        end
      end
    end

    describe "#open_webi" do
      before(:each) do
        @webi_report_engine = mock("WebiReportEngine").as_null_object
        @document_instance = mock("DocumentInstance").as_null_object
        @webi_instance = mock("WebiInstance").as_null_object
        class WebiReportEngine; end
        class WebiInstance; end
        WebiInstance.should_receive(:new).at_least(1).with(@document_instance).and_return(@webi_instance)
        @webi_report_engine.should_receive(:open).at_least(1).with("1234").and_return(@document_instance)
      end

      context "when :locale => en_US" do
        before(:each) do
          WebiReportEngine.should_receive(:new).once.with(@session, 'en_US').and_return(@webi_report_engine)
        end

        it "should create a WebiReportEngine and call #open" do
          @es.open_webi("1234")
        end

        it "should only create a WebiReportEngine once" do
          2.times{@es.open_webi("1234")}
        end

        it "should create a WebiInstance and return it" do
          @es.open_webi("1234").should == @webi_instance
        end
      end

      context "when :locale => en_CA" do
        before(:each) do
          WebiReportEngine.should_receive(:new).once.with(@session, 'en_CA').and_return(@webi_report_engine)
        end

        it "should pass any specified locale" do
          es = EnterpriseSession.new('cms', 'Administrator', '', :locale => 'en_CA')
          es.open_webi("1234")
        end
      end
    end
  end
end
