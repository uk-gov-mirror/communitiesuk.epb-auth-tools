module Auth
  class Token
    def initialize(payload)
      @payload = payload
    end

    def scope?(scope)
      @payload['scopes'].include? scope
    end
  end
end
