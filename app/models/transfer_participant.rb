class TransferParticipant < ActiveRecord::Base
  include Transitional

  belongs_to :participable
  belongs_to :user

  transitional :confirmation, state_machine_class_name: 'DisputeStateMachine'
end
