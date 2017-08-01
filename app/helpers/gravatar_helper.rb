
# default options: https://en.gravatar.com/site/implement/images/

module GravatarHelper
  def gravatar_url(email, size)
    gravatar = Digest::MD5::hexdigest(email).downcase
    url = "http://gravatar.com/avatar/#{gravatar}.png?s=#{size}&d=wavatar"
  end
end