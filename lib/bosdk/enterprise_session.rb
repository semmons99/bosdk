require 'bosdk/info_object'
require 'bosdk/webi_report_engine'
require 'bosdk/webi_instance'

module BOSDK
  # Creates a wrapper around the Business Objects Java SDK.
  class EnterpriseSession
    # The underlying IEnterpriseSession
    attr_reader :session

    # The underlying IInfoStore
    attr_reader :infostore

    # Creates a new EnterpriseSession object, connecting to the specified CMS.
    #  EnterpriseSession.new('cms', 'Administrator', '')
    #
    # Automatically calls disconnect when cleaned up.
    def initialize(cms, username, password, options = Hash.new)
      @session = CrystalEnterprise.getSessionMgr.logon(username, password, cms, 'secEnterprise')
      @infostore = @session.getService('', 'InfoStore')
      @connected = true
      @locale = options[:locale] || 'en_US'

      at_exit { disconnect }
    end

    # Returns true/false if connected to the CMS.
    def connected?
      return @connected
    end

    # Disconnects from the CMS is connected.
    def disconnect
      @session.logoff if connected?
      @session = nil
      @connected = false
      nil
    end

    # Converts 'path://', 'query://' and 'cuid://' special forms to a SDK query
    def path_to_sql(path_stmt)
      @infostore.getStatelessPageInfo(path_stmt, PagingQueryOptions.new).getPageSQL
    end

    # Queries the InfoStore with the provided statement, returning an Array of
    # InfoObject(s).
    def query(stmt)
      sql = stmt.match(/^(path|query|cuid):\/\//i) ? path_to_sql(stmt) : stmt
      @infostore.query(sql).map{|o| InfoObject.new(o)}
    end

    # Open a Webi document from the provided docid
    def open_webi(docid)
      @webi_report_engine ||= WebiReportEngine.new(@session, @locale)
      WebiInstance.new(@webi_report_engine.open(docid))
    end
  end
end
