# frozen_string_literal: true

require 'twitter_api'

Onebox.options = {
  twitter_client: TwitterApi,
  redirect_limit: 3,
  user_agent: "Discourse Forum Onebox v#{DiscourseVersion::VERSION::STRING}"
}
