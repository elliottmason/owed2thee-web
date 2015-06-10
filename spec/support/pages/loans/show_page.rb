module Loans
  class ShowPage < SitePrism::Page
    set_url_matcher %r{loans/\d+}
  end
end
