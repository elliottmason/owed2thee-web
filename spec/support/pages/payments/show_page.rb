module Payments
  class ShowPage < SitePrism::Page
    set_url_matcher %r{payments/\d+}
  end
end
