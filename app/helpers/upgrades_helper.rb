module UpgradesHelper
  def tab_link(icon, url, title)
    classes = ["tab"]
    classes << "selected" if url == request.request_uri
    content_tag(:li, link_to(icon, url, :title => title), :class => classes.join(" "))
  end
end