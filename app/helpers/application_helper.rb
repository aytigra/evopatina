module ApplicationHelper
  def menu_langs
    I18n.available_locales.reject{|l| l == I18n.locale}
  end
end
