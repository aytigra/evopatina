module ApplicationHelper
  def menu_langs
    I18n.available_locales.reject{|l| l == I18n.locale}
  end

  def nav_link(text, path)
    options = current_page?(path) ? { class: "active" } : {}
    content_tag(:li, options) do
      link_to text, path
    end
  end
end
