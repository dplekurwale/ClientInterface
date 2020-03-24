class JsonWebToken
  class << self
    def encode(payload, exp = 2.hours.from_now)
      begin
        payload[:exp] = exp.to_i
        JWT.encode(payload, Rails.application.credentials.hmac_secret, 'HS256')
      rescue => e
        nil
      end
    end

    def decode(token)
      begin
        body = JWT.decode(token, Rails.application.credentials.hmac_secret, true, { algorithm: 'HS256' })[0]
        HashWithIndifferentAccess.new body
      rescue => e
        nil
      end
    end
  end
end