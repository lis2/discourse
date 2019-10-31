# frozen_string_literal: true

class TopicPosterSerializer < ApplicationSerializer
  root 'topic_poster'

  attributes :extras, :description
  has_one :user, serializer: BasicUserSerializer
  has_one :primary_group, serializer: PrimaryGroupSerializer
end
