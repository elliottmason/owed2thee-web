module Paginated
  def page(page, per_page)
    limit = per_page
    offset = (page - 1) * per_page

    limit(limit).offset(offset)
  end
end
