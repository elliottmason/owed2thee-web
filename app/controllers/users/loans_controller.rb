module Users
  class LoansController < BaseController
    ACTIVITIES_PER_PAGE = 10
    LOANS_PER_PAGE      = 10

    def index
      authorize(:Activity)
      authorize(Loan)

      retrieve_grouped_activities
      retrieve_grouped_loans
    end

    private

    def group_records(records)
      GroupRecordsByCreationDate.with(records)
    end

    def index_params
      @index_params ||= LoansParams.new(params)
    end

    def retrieve_activities
      policy_scope(:Activity).
        page(index_params.page).
        per(ACTIVITIES_PER_PAGE)
    end

    def retrieve_grouped_activities
      @activities         = retrieve_activities
      @grouped_activities = group_records(@activities)
    end

    def retrieve_grouped_loans
      @loans          = retrieve_loans
      @grouped_loans  = group_records(@loans)
    end

    def retrieve_loans
      policy_scope(Loan).
        page(index_params.page).
        per(LOANS_PER_PAGE)
    end
  end
end
