module Users
  class LoansController < BaseController
    def index
      loans = LoanQuery.paginated_for_user(current_user, index_params.page)
      @loans = GroupRecordsByCreationDate.with(loans)

      activities = ActivityQuery.paginated_for_user(current_user, index_params.page)
      @activities = GroupRecordsByCreationDate.with(activities)
    end

    private

    def index_params
      @index_params ||= LoansParams.new(params)
    end
  end
end
