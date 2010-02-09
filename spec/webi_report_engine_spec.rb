$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'bosdk/webi_report_engine'

module BOSDK
  describe WebiReportEngine do
    before(:each) do
      @enterprise_session = mock("EnterpriseSession").as_null_object
      @report_engines = mock("ReportEngines").as_null_object
      @webi_report_engine = mock("ReportEngine").as_null_object

      @enterprise_session.should_receive(:getService).at_least(1).with("ReportEngines").and_return(@report_engines)
      module ReportEngines; module ReportEngineType; module WI_REPORT_ENGINE; end; end; end
      @report_engines.should_receive(:getService).at_least(1).with(ReportEngines::ReportEngineType::WI_REPORT_ENGINE).and_return(@webi_report_engine)
      @webi_report_engine.should_receive(:setLocale).at_least(1).with("en_US")
      #@enterprise_session.should_receive(:setAttribute).at_least(1).with("widReportEngine", @webi_report_engine)

      @wre = WebiReportEngine.new(@enterprise_session)
    end

    describe "#new" do
      before(:each) do
        @webi_report_engine.should_receive(:setLocale).once.with("en_CA")
      end

      it "should allow you to set the locale" do
        WebiReportEngine.new(@enterprise_session, "en_CA")
      end
    end

    describe "#open" do
      before(:each) do
        @webi_report_engine.should_receive(:openDocument).once.with("1234")
      end

      it  "should call the underlying #openDocument with the supplied docid" do
        @wre.open("1234")
      end
    end
  end
end
