module PublicActivity
  module Loan
    class CreatedView
      delegate :created_at, :key, :trackable, to: :activity
      alias_method :loan, :trackable

      def initialize(activity, current_user)
        @activity     = activity
        @current_user = current_user
      end

      def amount
        loan.amount
      end

      def borrowers
      end

      def creator
      end

      private

      attr_reader :activity
    end
  end
end
