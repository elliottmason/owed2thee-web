module PublicActivity
  module Loan
    class ActivityView
      delegate :created_at, :key, :trackable, to: :activity
      alias_method :loan, :trackable

      def initialize(activity, current_user)
        @activity     = activity
        @current_user = current_user
      end

      def actor
        @actor ||= UserPresenter.new(activity.owner, current_user, loan)
                   .display_name
      end

      def amount_lent
        loan.amount.symbol + loan.amount.to_s
      end

      def borrowers
        return @borrowers if @borrowers

        @borrowers ||= 'you' if loan.borrower == current_user
        @borrowers ||= '' if loan.borrower == activity.owner
        @borrowers ||= join_display_names(loan.borrowers)
      end

      def lenders
        return @lenders if @lenders

        @lenders ||= 'you' if loan.lender == current_user
        @lenders ||= '' if loan.lender == activity.owner
        @lenders ||= join_display_names(loan.lenders)
      end

      private

      attr_reader :activity
      attr_reader :current_user

      def join_display_names(users)
        Burgundy::Collection.new(
          users,
          UserPresenter,
          current_user,
          loan
        ).map(&:display_name).join(', ')
      end
    end
  end
end
