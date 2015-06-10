class Ledger::LedgerUniquenessValidator < ActiveModel::Validator
  def validate(record)
    if record.user_a == record.user_b
      record.errors[:base] << 'Cannot create ledger between identical users'
      return
    end

    record.errors[:base] << 'Ledger between users exists' \
      if Ledger.where(user_a: record.user_b, user_b: record.user_a).first
  end
end
