class Ledger::LedgerUniquenessValidator < ActiveModel::Validator
  def validate(record)
    if record.user_a == record.user_b
      record.errors[:base] << 'Cannot create ledger between identical users'
      return
    end

    record.errors[:base] << 'Ledger between users exists' \
      if Ledger.between(record.user_a, record.user_b).first
  end
end
