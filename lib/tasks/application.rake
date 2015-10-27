task :stats do
  require 'rails/code_statistics'

  exclude_directories = [
    'support'
  ]

  ::STATS_DIRECTORIES = []
  %w(app spec).each do |type|
    dirs = Dir.entries(type).select do |entry|
      File.directory?(File.join(type, entry)) &&
      entry != '.' &&
      entry != '..' &&
      entry != 'assets' &&
      entry != 'views'
    end

    dirs.each do |directory|
      directory = directory.to_s
      next if exclude_directories.include?(directory.to_s)

      name = directory.titleize
      is_spec = (type == 'spec' && !%w(Factories Pages).include?(name))
      name = is_spec ? "#{name.singularize} specs" : name

      ::STATS_DIRECTORIES << [name, "#{type}/#{directory}"]
      CodeStatistics::TEST_TYPES << name if type == 'spec'
    end
  end
end
