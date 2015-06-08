task :stats do
  require 'rails/code_statistics'

  ::STATS_DIRECTORIES = []
  %w(app spec).each do |type|
    dirs =  Dir.entries(type).select do |entry|
      File.directory?(File.join(type, entry)) &&
      entry != '.' &&
      entry != '..' &&
      entry != 'assets' &&
      entry != 'views'
    end

    dirs.each do |directory|
      name = directory.to_s.titleize
      name = type == 'spec' ? "#{name} specs" : name
      ::STATS_DIRECTORIES << [name, "#{type}/#{directory}"]
      CodeStatistics::TEST_TYPES << name if type == 'spec'
    end
  end
end
