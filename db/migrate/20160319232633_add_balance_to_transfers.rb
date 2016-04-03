class AddBalanceToTransfers < ActiveRecord::Migration
  def change
    add_monetize :transfers, :balance
  end
end
