class GroupRecords
  def self.with(records, attribute = nil, cast_method = nil)
    result = ActiveSupport::OrderedHash.new
    records.each do |record|
      next unless record.send(attribute)

      key = record.send(attribute)
      key = key.send(cast_method) if cast_method
      result[key] ||= []
      result[key] << record
    end
    result
  end
end

class GroupRecordsByCreationDate < GroupRecords
  def self.with(*args)
    super(*args, :created_at, :to_date)
  end
end
