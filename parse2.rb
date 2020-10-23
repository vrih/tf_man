#!/usr/bin/env ruby

require 'json'
require 'open3'

INPUT=ARGV[0]
TYPE=ARGV[1]

def process(file, section, f)
  content = File.read(file)
  slug = f.gsub('.html.markdown', '')
  title = content.match(/page_title: ["'](.*)["']/)[1]
  description = content.match(/description: (\|- *\n  )?(.*)\n---/m)[2]
  content.gsub!(/^# Resource:/, "## NAME\n#{title} \\- #{description}")
  content.gsub!(/^#/, '')
  content.gsub!('page_title:', 'title:')
  stdout_str, exit_code = Open3.capture2("pandoc -f markdown -t man -s -o tf_#{TYPE}_#{section}_#{slug}.5", stdin_data: content)
end

# https://github.com/terraform-providers/terraform-provider-aws/archive/v3.12.0.tar.gz
Dir.foreach("#{INPUT}/d") do |f|
  p f
  process("#{INPUT}/d/#{f}", 'data', f) if f.end_with? '.html.markdown'
end

Dir.foreach("#{INPUT}/r") do |f|
  p f
  process("#{INPUT}/r/#{f}", 'resource', f) if f.end_with? '.html.markdown'
end

