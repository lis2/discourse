# frozen_string_literal: true

module Jobs
  class CleanUpSidekiqStatistic < Jobs::OnceoffJob
    def execute_onceoff(args)
      $redis.without_namespace.del('sidekiq:sidekiq:statistic')
    end
  end
end
