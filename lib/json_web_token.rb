class JsonWebToken
  HMAC_SECRET = Rails.application.secrets.secret_key_base
  ALGORITHM = "HS256".freeze

  def self.encode payload, exp = 24.hours.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, HMAC_SECRET, ALGORITHM)
  end

  def self.decode token
    body = JWT.decode(token, HMAC_SECRET, true, {algorithm: ALGORITHM}).first
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
    raise ExceptionHandler::InvalidVerification, e
  end
end
