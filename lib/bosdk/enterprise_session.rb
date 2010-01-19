module BOSDK
  class EnterpriseSession
    attr_reader :boe

    def initialize(cms, username, password)
      @boe = CrystalEnterprise.getSessionMgr.logon(username, password, cms, 'secEnterprise')
      @connected = true

      at_exit { disconnect }
    end

    def connected?
      return @connected
    end

    def disconnect
      @boe.logoff if connected?
      @boe = nil
      @connected = false
    end
  end
end
