class GroupLoansByDate
  def self.with(loans)
    result = ActiveSupport::OrderedHash.new
    loans.each do |loan|
      if loan.created_at
        result[loan.created_at.to_date] ||= []
        result[loan.created_at.to_date] << loan
      end
    end
    result
  end
end
