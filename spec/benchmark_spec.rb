require 'rails_helper'

class FastJsonApiTopicSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :fancy_title, :slug, :posts_count
end

describe "compare AMS with fastjson_api" do
  before do
    1000.times do
      Fabricate(:topic)
    end
  end

  it 'topic-10 ams' do
    topics = Topic.limit(10)

    ams_time = Benchmark.measure  do
      topics.map { |topic| BasicTopicSerializer.new(topic).to_json }
    end.real * 1000

    puts "ams 10 - #{ams_time}"
  end

  it 'topic-10 fast' do
    topics = Topic.limit(10)

    fast_json_time = Benchmark.measure  do
      topics.map { |topic| FastJsonApiTopicSerializer.new(topic).serialized_json }
    end.real * 1000

    puts "fast 10 - #{fast_json_time}"
  end

  it 'topic-50 ams' do
    topics = Topic.limit(50)

    ams_time = Benchmark.measure  do
      topics.map { |topic| BasicTopicSerializer.new(topic).to_json }
    end.real * 1000

    puts "ams 50 - #{ams_time}"
  end

  it 'topic-50 fast' do
    topics = Topic.limit(50)

    fast_json_time = Benchmark.measure  do
      topics.map { |topic| FastJsonApiTopicSerializer.new(topic).serialized_json }
    end.real * 1000

    puts "fast 50 - #{fast_json_time}"
  end

  it 'topic-100 ams' do
    topics = Topic.limit(100).to_a

    ams_time = Benchmark.measure  do
      topics.map { |topic| BasicTopicSerializer.new(topic).to_json }
    end.real * 1000

    puts "ams 100 - #{ams_time}"
  end

  it 'topic-100 fast' do
    topics = Topic.limit(100).to_a

    fast_json_time = Benchmark.measure  do
      topics.map { |topic| FastJsonApiTopicSerializer.new(topic).serialized_json }
    end.real * 1000

    puts "fast 100 - #{fast_json_time}"
  end

  it 'topic-1000 ams' do
    topics = Topic.limit(1000).to_a

    ams_time = Benchmark.measure  do
      topics.map { |topic| BasicTopicSerializer.new(topic).to_json }
    end.real * 1000

    puts "ams 1000 - #{ams_time}"
  end

  it 'topic-1000 fast' do
    topics = Topic.limit(1000).to_a

    fast_json_time = Benchmark.measure  do
      topics.map { |topic| FastJsonApiTopicSerializer.new(topic).serialized_json }
    end.real * 1000

    puts "fast 1000 - #{fast_json_time}"
  end
end
