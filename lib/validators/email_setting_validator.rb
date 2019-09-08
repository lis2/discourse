# frozen_string_literal: true

module Validators; end
class Validators::EmailSettingValidator
  def initialize(opts = {})
    @opts = opts
  end

  def valid_value?(val)
    !val.present? || !!(EmailValidator.email_regex =~ val)
  end

  def error_message
    I18n.t('site_settings.errors.invalid_email')
  end
end
