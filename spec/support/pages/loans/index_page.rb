module Loans
  class IndexPage < SitePrism::Page
    set_url 'loans{/page}'
    set_url_matcher(%r{loans(?:/\d+)?$})

    section :pagination, '.pagination' do
      elements :pages, 'a'

      def click_page(page_number)
        pages.find { |p| p.text == page_number.to_s }.click
      end
    end

    def current_page
      current_url.match(%r{loans/(\d+)})[1].to_s.to_i
    end
  end
end
