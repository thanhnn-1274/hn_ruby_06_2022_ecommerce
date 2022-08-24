module Errors
  class MessageError < Errors::ApplicationError
    def initialize error
      super
      @error = error.class.to_s.split("::")[1].underscore
    end

    def serialize
      {
        messages: Message.send(@error.to_s),
        code: code
      }
    end

    private

    def code
      I18n.t @error,
             locale: :api,
             scope: [:api, :errors, :code],
             default: @error
    end
  end
end
