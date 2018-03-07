module PagesHelper

  def page_editors(page)
    users = []
    page.audits.each do |a|
      users << a.user
    end
    users.uniq
  end

end
