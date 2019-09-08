# frozen_string_literal: true

require 'migration/safe_migrate'

Migration::SafeMigrate.patch_active_record!
