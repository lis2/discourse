# frozen_string_literal: true

if ENV['RAILS_ENV'] != "production"
  exec "RAILS_ENV=production ruby #{__FILE__}"
end

require 'fabrication'
require File.expand_path("../../config/environment", __FILE__)

class FastJsonApiTopicSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :fancy_title, :slug, :posts_count
end

if Topic.count < 500
  500.times do
    Fabricate(:topic)
  end
end

results = {}

[10,50, 100, 200, 500].each do |limit|
  topics = Topic.limit(limit)

  #warmup

  fast = topics.map { |topic| FastJsonApiTopicSerializer.new(topic).serialized_json }
  ams = topics.map { |topic| BasicTopicSerializer.new(topic).to_json }
  ams_fixed = topics.map { |topic| ActiveSupport::JSON.encode(basic_topic: BasicTopicSerializer.new(topic).attributes) }
  raise "Different results" if ams != ams_fixed


  results["ams-#{limit}"] = []
  results["fast-#{limit}"] = []
  results["ams-fixed-#{limit}"] = []

  500.times do
    results["ams-#{limit}"] << Benchmark.measure  do
      topics.map { |topic| BasicTopicSerializer.new(topic).to_json }
    end.real * 1000
    results["fast-#{limit}"] << Benchmark.measure  do
      topics.map { |topic| FastJsonApiTopicSerializer.new(topic).serialized_json }
    end.real * 1000
    results["ams-fixed-#{limit}"] << Benchmark.measure  do
      topics.map { |topic| ActiveSupport::JSON.encode(basic_topic: BasicTopicSerializer.new(topic).attributes) }
    end.real * 1000
  end
end

results.each do |key, values|
  puts "#{key}: #{values.min}"
end

# topics = Topic.limit(100)
# topics.map { |topic| BasicTopicSerializer.new(topic).to_json }
# topics.map { |topic| FastJsonApiTopicSerializer.new(topic).serialized_json }

# StackProf.run(mode: :cpu, out: 'ams2.dump', raw: true) do
#   100.times do
#     topics.map { |topic| BasicTopicSerializer.new(topic).to_json }
#   end
# end

# StackProf.run(mode: :cpu, out: 'fast2.dump', raw: true) do
#   100.times do
#     topics.map { |topic| FastJsonApiTopicSerializer.new(topic).serialized_json }
#   end
# end
