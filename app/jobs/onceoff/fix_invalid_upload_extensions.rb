# frozen_string_literal: true

require "upload_fixer"

module Jobs
  class FixInvalidUploadExtensions < Jobs::OnceoffJob
    def execute_onceoff(args)
      UploadFixer.fix_all_extensions
    end
  end
end
