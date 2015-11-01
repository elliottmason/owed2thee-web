module PublicActivity
  module Loan
    class CreatedView
      delegate :created_at, :key, :trackable, to: :activity
      alias_method :loan, :trackable

      def initialize(activity, current_user)
        @activity     = activity
        @current_user = current_user
      end

      def amount_lent
        loan.amount
      end

      def borrowers
        return @borrowers if @borrowers

        @borrowers = Burgundy::Collection.new(
          loan.borrowers,
          UserPresenter,
          current_user,
          loan
        ).map(&:display_name).join(', ')
      end

      def creator
        return @creator if @creator

        @creator = UserPresenter.new(loan.creator, current_user, loan)
      end

      private

      attr_reader :activity
      attr_reader :current_user
    end
  end
end
