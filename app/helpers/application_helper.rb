module ApplicationHelper
  def url_with_protocol(url)
    if url.blank?
      return ""
    else
      /^http/i.match(url) ? url : "http://#{url}"
    end

  end
end
