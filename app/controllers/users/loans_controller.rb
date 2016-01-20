module Users
  class LoansController < BaseController
    def index
      authorize(:Activity)
      authorize(Loan)

      loans = policy_scope(Loan).page(index_params.page)
      @loans = GroupRecordsByCreationDate.with(loans)

      activities = policy_scope(:Activity) \
                   .page(index_params.page)
      @activities = GroupRecordsByCreationDate.with(activities)
    end

    private

    def index_params
      @index_params ||= LoansParams.new(params)
    end
  end
end
