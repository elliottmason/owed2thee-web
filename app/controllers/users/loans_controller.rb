module Users
  class LoansController < BaseController
    def index
      loans = LoanQuery.paginated_for_user(current_user, params[:page])
      @loans = GroupLoansByDate.with(loans)
    end

    private

    def page
      return @_page if @_page

      @_page = case params[:page]
               when NilClass then 1
               else params[:page].to_i
              end
      @_page = 1 if @_page < 1
      @_page
    end
  end
end
