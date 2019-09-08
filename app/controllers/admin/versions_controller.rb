# frozen_string_literal: true

require 'discourse_updates'

class Admin::VersionsController < Admin::AdminController
  def show
    render json: DiscourseUpdates.check_version
  end
end
