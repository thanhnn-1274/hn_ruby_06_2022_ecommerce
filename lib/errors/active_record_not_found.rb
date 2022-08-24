module Errors
  class ActiveRecordNotFound < Errors::ApplicationError
    attr_reader :model, :field, :detail, :message_key

    def initialize error, message: nil
      super
      @model = error.model.underscore
      @detail = error.class.to_s.split("::")[1].underscore
      @field = error.primary_key
      @message_key = message || :default
      @errors = serialize
    end

    def serialize
      {
        resource: resource,
        field: @model.to_s,
        code: @model.to_s,
        message: message
      }
    end

    private
    def message
      Message.not_found @model
    end

    def code
      I18n.t @detail,
             locale: :api,
             scope: [:api, :errors, :code],
             default: @detail
    end
  end
end
