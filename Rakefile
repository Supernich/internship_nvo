task :create_directory, [:dir_name] => :check_directory do |task, args|
  if @dir_exist
    p 'Directory already exist'
    return
  end
  create_directory(args[:dir_name])
end

task :check_directory, :directory do |task, args|
  check_directory(args[:dir_name] || args[:directory])
end

def create_directory(dir_path)
  check_directory(dir_path)
  return if @dir_exist

  dir = dir_path.split('/')
  dir.delete(dir.first) if dir.length > 1
  dir.each do |path|
    mkdir path
    cd path
  end
end

def check_directory(dir_path)
  pathname = "./#{dir_path}"
  @dir_exist = Dir.exist?(pathname)
end

task :create_file, [:file_path] => :check_file do |task, args|
  if @file_exist
    p 'File already exist'
    return
  end
  path = args[:file_path].split('/')
  if path.length > 1
    path_string = ''
    (path.length - 1).times do |i|
      path_string += "/#{path[i]}"
    end
    create_directory(path_string)
  end
  touch(args[:file_path]) unless @file_exist
end

task :check_file, :path_to_file do |task, args|
  path = args[:file_path] || args[:path_to_file]
  @file_exist = File.exist?(path)
end

desc 'Set timezone'
task :set_timezone do
  ENV['TZ'] = 'UTC'

end

desc 'Show time'
task default: :set_timezone do
  puts "#{Time.now}"
end

namespace :work_with_files do
  task :create_directory do
    mkdir_p('New_directory')
    cd('New_directory')
    touch('Some_file.rb')
  end
end
