module LoanRequests
  class ShowPage  < SitePrism::Page
    set_url '/loan_requests{/uuid}'
    set_url_matcher %r{loan_requests/[a-z\d]+}
  end
end
