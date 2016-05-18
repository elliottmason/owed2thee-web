class LoanRequestQuery < ApplicationQuery
  def self.index_for_user(_user)
    # grab all requests visible to everyone, i.e. global: true
    # append requests open to all known contacts
    # all known contacts except certain contacts
    # only certain contacts
  end

  def self.uuid!(uuid)
    LoanRequest.find_by_uuid(uuid)
  end

  module Scopes
  end
end
