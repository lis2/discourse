# frozen_string_literal: true

module Jobs
  class CreateTagsSearchIndex < Jobs::OnceoffJob
    def execute_onceoff(args)
      DB.query('select id, name from tags').each do |t|
        SearchIndexer.update_tags_index(t.id, t.name)
      end
    end
  end
end
