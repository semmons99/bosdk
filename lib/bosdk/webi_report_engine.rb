module BOSDK
  # Creates a wrapper around a Webi based ReportEngine.
  class WebiReportEngine
    # The underlying ReportEngine.
    attr_reader :webi_report_engine

    # Creates a new ReportEngine using the provided EnterpriseSession and an
    # optional locale setting.
    #  WebiReportEngine.new(enterprise_session)
    def initialize(enterprise_session, locale = "en_US")
      @webi_report_engine = enterprise_session.getService("", "WebiReportEngine")
      @webi_report_engine.setLocale(locale)
    end

    # Opens the webi document specified by the docid.
    def open(docid)
      @webi_report_engine.openDocument(docid)
    end
  end
end
