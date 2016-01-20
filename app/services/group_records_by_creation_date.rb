class GroupRecordsByCreationDate < GroupRecords
  def self.with(*args)
    super(*args, :created_at, :to_date)
  end
end
