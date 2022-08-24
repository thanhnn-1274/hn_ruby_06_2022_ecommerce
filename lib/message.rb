class Message
  class << self
    def not_found record = "record"
      "Sorry, #{record} not found."
    end

    def invalid_credentials
      "Invalid credentials"
    end

    def invalid_verification
      "Invalid token"
    end

    def missing_token
      "Missing token"
    end

    def authentication_failed
      "You need to log in to use the app"
    end

    def unauthorized
      "You do not have permission to access this page!!"
    end

    def account_created
      "Account created successfully"
    end

    def account_not_created
      "Account could not be created"
    end

    def expired_token
      "Sorry, your token has expired. Please login to continue."
    end

    def login_failed
      "Invalid email/password combination"
    end

    def access_denied
      "Access denied. You are not authorized to access the requested page."
    end
  end
end
