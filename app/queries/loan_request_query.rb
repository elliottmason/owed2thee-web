class LoanRequestQuery < ApplicationQuery
  def self.uuid!(uuid)
    LoanRequest.where(uuid: uuid).first!
  end
end
