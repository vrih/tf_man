require 'json'
require 'open3'

INPUT=ARGV[0]
TYPE=ARGV[1]

data = File.read(INPUT)
a = JSON.parse(data)

a['included'].each do |doc|
  p doc['attributes']['slug']
  attr = doc['attributes']
  section = attr['category']
  section = 'data' if attr['category'] == 'data_source'
  content = "#{attr['content']}"
  content.gsub!(/^# Resource:/, "## NAME\n#{attr['title']} \\- #{attr['description']}")
  content.gsub!(/^#/, '')
  content.gsub!('page_title:', 'title:')
  stdout_str, exit_code = Open3.capture2("pandoc -f markdown -t man -s -o tf_#{TYPE}_#{section}_#{doc['attributes']['slug']}.5", stdin_data: content)
end
