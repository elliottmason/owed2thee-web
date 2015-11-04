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
        return @actor if @actor

        actor = case key.gsub('loan.', '')
                when 'created'
                  loan.creator
                when 'confirmed'
                  activity.owner
                end
        @actor = UserPresenter.new(actor, current_user, loan).display_name
      end

      def amount_lent
        loan.amount.symbol + loan.amount.to_s
      end

      def borrowers
        return @borrowers if @borrowers

        @borrowers ||= '' if loan.borrower == activity.owner
        @borrowers ||= Burgundy::Collection.new(
          loan.borrowers,
          UserPresenter,
          current_user,
          loan
        ).map(&:display_name).join(', ')
      end

      def lenders
        return @lenders if @lenders

        @lenders = '' if loan.lender == loan.creator
        @lenders = 'you' if loan.lender == current_user
        @lenders ||= Burgundy::Collection.new(
          loan.lenders,
          UserPresenter,
          current_user,
          loan
        ).map(&:display_name).join(', ')
      end

      private

      attr_reader :activity
      attr_reader :current_user
    end
  end
end
