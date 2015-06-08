#!/usr/bin/ruby
#encoding: UTF-8

require 'digest'
require 'fileutils'

@duplicate = {}

def directory(path)
  Dir.entries(path).each do |d|
    next if d == '.' or d == '..'

    new_path = path + '/' + d
    if File.directory?(new_path)
      directory(new_path)
    else
      file(new_path)
    end
  end
end

def file(path)
  p path

  begin
    hash_file = Digest::MD5.hexdigest(File.read(path))
    if @duplicate[hash_file]
      @duplicate[hash_file] += 1
      FileUtils.remove_file(path)
    else
      @duplicate[hash_file] = 1
    end
  rescue Exception => e
    p e
  end
end

path = ARGV.first

if path
  if File.directory?(path)
    directory(path)
  else
    puts 'not is a folder'
    exit
  end
else
  puts 'most past folder'
end

count_files = 0

@duplicate.each do |k, v|
  if v > 1
    count_files += 1
    puts k
  end
end

puts "duplicate files #{count_files}"
