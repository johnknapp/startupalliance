module PagesHelper

  def markdown(text)
    options = {
        filter_html:     true,
        no_images:       true,
        hard_wrap:       true,
        link_attributes: { rel: 'nofollow', target: "_blank" },
        space_after_headers: true,
        fenced_code_blocks: true
    }

    extensions = {
        autolink:           true,
        superscript:        true,
        disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def page_editors(page)
    users = []
    page.audits.each do |a|
      users << a.user
    end
    users.uniq
  end
end
