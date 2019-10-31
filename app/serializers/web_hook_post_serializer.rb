# frozen_string_literal: true

class WebHookPostSerializer < PostSerializer
  root 'web_hook_post'

  attributes :topic_posts_count,
             :topic_archetype,
             :category_slug

  def include_topic_title?
    true
  end

  %i{
    can_view
    can_edit
    can_delete
    can_recover
    can_wiki
    actions_summary
    can_view_edit_history
    yours
    primary_group_flair_url
    primary_group_flair_bg_color
    primary_group_flair_color
    notice_args
    notice_type
  }.each do |attr|
    define_method("include_#{attr}?") do
      false
    end
  end

  def topic_posts_count
    object.topic ? object.topic.posts_count : 0
  end

  def topic_archetype
    object.topic ? object.topic.archetype : ''
  end

  def include_category_slug?
    object.topic && object.topic.category
  end

  def category_slug
    object.topic && object.topic.category ? object.topic.category.slug_for_url : ''
  end

  def include_readers_count?
    false
  end
end
