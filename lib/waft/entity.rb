require 'rotp'
require 'rqrcode'

module Waft
  class Entity
    attr_reader :secret, :account, :issuer

    def initialize(param)
      @secret = param[:secret]
      @account = param[:account]
      @issuer = param[:issuer]
    end

    def <=>(target)
      r = self.issuer <=> target.issuer
      return r if r != 0
      return self.account <=> target.account
    end

    def to_h
      { secret: @secret, account: @account, issuer: @issuer }
    end

    def totp
      @issuer.nil? ? ROTP::TOTP.new(@secret) : ROTP::TOTP.new(@secret, issuer: @issuer)
    end

    def otp
      totp.now
    end

    def provisioning_uri
      totp.provisioning_uri(@account)
    end

    def qr(options=nil)
      RQRCode::QRCode.new(provisioning_uri, options)
    end
  end
end
