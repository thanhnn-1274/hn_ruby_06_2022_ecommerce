class ValidationErrorSerializer
  def initialize record, field, detail, message
    @record = record
    @field = field
    @detail = detail
    @message = message
  end

  def serialize
    {
      resource: resource,
      field: field,
      code: code,
      message: @message
    }
  end

  private
  def resource
    underscored_resource_name
  end

  def field
    @field.to_s
  end

  def code
    I18n.t @detail,
           locale: :api,
           scope: [:api, :errors, :code],
           default: @detail.to_s
  end

  def underscored_resource_name
    @record.class.to_s.gsub("::", "").underscore
  end
end
