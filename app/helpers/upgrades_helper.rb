module UpgradesHelper
  def tab_link(icon, url, title)
    classes = ["tab"]
    classes << "selected" if url == request.request_uri
    content_tag(:li, link_to(icon, url, :title => title), :class => classes.join(" "))
  end
  def beta_upgrade
    content_tag :span, "(Beta)", :class => "beta", :title => "This upgrade is still in beta, please take it with a grain of salt"
  end
end