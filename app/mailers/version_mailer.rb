# frozen_string_literal: true

require 'email/message_builder'

class VersionMailer < ActionMailer::Base
  include Email::BuildEmailHelper

  def send_notice
    if SiteSetting.contact_email.present?
      missing_versions = DiscourseUpdates.missing_versions
      if missing_versions.present? && missing_versions.first['notes'].present?
        build_email(SiteSetting.contact_email,
                     template: 'new_version_mailer_with_notes',
                     notes: missing_versions.first['notes'],
                     new_version: DiscourseUpdates.latest_version,
                     installed_version: DiscourseVersion::VERSION::STRING)
      else
        build_email(SiteSetting.contact_email,
                     template: 'new_version_mailer',
                     new_version: DiscourseUpdates.latest_version,
                     installed_version: DiscourseVersion::VERSION::STRING)
      end
    end
  end
end
