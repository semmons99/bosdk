require 'bosdk/info_object'

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
    def initialize(cms, username, password)
      @session = CrystalEnterprise.getSessionMgr.logon(username, password, cms, 'secEnterprise')
      @infostore = @session.getService('', 'InfoStore')
      @connected = true

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

    # Queries the InfoStore with the provided statement, returning an Array of
    # InfoObject(s).
    def query(stmt)
      @infostore.query(stmt).map{|o| InfoObject.new(o)}
    end
  end
end
