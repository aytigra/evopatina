module ApplicationHelper
  def menu_langs
    I18n.available_locales.reject { |l| l == I18n.locale }
  end

  def nav_link(text, path)
    options = current_page?(path) ? { class: "active" } : {}
    content_tag(:li, options) do
      link_to text, path
    end
  end

  def gliph(gliph)
    content_tag(:span, '', class: 'glyphicon glyphicon-' + gliph, 'aria-hidden' => "true") + ' '
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
