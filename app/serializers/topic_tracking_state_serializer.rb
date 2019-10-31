# frozen_string_literal: true

class TopicTrackingStateSerializer < ApplicationSerializer
  root 'topic_tracking_state'

  attributes :topic_id,
             :highest_post_number,
             :last_read_post_number,
             :created_at,
             :category_id,
             :notification_level
end
