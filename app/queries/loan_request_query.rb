class LoanRequestQuery < ApplicationQuery
  def self.index_for_user(user)
    new
      .relation
      .globally_visible
    # grab all requests visible to everyone, i.e. global: true
    # append requests open to all known contacts
    # all known contacts except certain contacts
    # only certain contacts
  end

  def self.uuid!(uuid)
    LoanRequest.find_by_uuid(uuid)
  end

  module Scopes
    def globally_visible
      where(globally_visible: true)
    end
  end
end

# should lending improve credit score?
# you don't pay back your debts, but you aren't a complete user, this should
#   count for something
# capacity to lend reveals altruism, arguably a factor in creditworthiness
