class AddLoanRequestToTransfers < ActiveRecord::Migration
  def change
    add_belongs_to :transfers, :loan_request, index: true
  end
end
