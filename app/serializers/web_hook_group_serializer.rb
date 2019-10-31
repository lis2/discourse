# frozen_string_literal: true

class WebHookGroupSerializer < BasicGroupSerializer
  root 'web_hook_group'

  %i{
    is_group_user
    is_group_owner
  }.each do |attr|
    define_method("include_#{attr}?") do
      false
    end
  end

end
