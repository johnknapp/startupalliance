module ApplicationHelper

  def gvo_url(minus_hours = 0)
    time = Time.zone.now.utc.beginning_of_day-minus_hours.hours
    'https://meet.jit.si/sa-gvo-' + Digest::SHA1.hexdigest(time.to_s)
  end

  # default options: https://en.gravatar.com/site/implement/images/
  def gravatar_url(email, size)
    gravatar = Digest::MD5::hexdigest(email).downcase
    url = "http://gravatar.com/avatar/#{gravatar}.png?s=#{size}&d=wavatar"
  end

  def markdown(text)
    options = {
        filter_html:     true,
        # no_images:       true,
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

end