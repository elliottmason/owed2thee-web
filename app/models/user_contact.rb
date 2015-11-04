# UserContact records are created when a user interacts with another user, thus
# signifying that the owner's full name and profile can be viewed by the
# contact. These records are likely created when a user confirms participation
# in a loan.
class UserContact < ActiveRecord::Base
  belongs_to :contact, class_name: 'User'
  belongs_to :user
  belongs_to :source, polymorphic: true
end