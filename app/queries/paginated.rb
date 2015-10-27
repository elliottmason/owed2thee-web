module Paginated
  PER_PAGE = 15

  def self.included(base)
    base.const_set(:PER_PAGE, Paginated::PER_PAGE) \
      unless base.const_defined?(:PER_PAGE)
  end

  def page(page, per_page = PER_PAGE)
    limit = per_page
    offset = (page - 1) * per_page

    limit(limit).offset(offset)
  end
end
