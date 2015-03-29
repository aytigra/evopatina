class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  protected
    def set_locale
      if params_locale = sanitize_locale(params[:locale])
        I18n.locale = params_locale
        save_locale_to_user
        save_locale_to_cookie
      elsif user_locale = get_user_locale
        I18n.locale = user_locale
        save_locale_to_cookie
      elsif cookie_locale = sanitize_locale(cookies['locale'])
        I18n.locale = cookie_locale
        save_locale_to_user
      else
        require 'http_accept_language_parser.rb'
        parser = HttpAcceptLanguage::Parser.new(env["HTTP_ACCEPT_LANGUAGE"])
        I18n.locale = parser.compatible_language_from(I18n.available_locales)
      end
    end

    def save_locale_to_user
      if user_signed_in?
        user = User.find(current_user.id)
        user.locale = I18n.locale
        user.save
      end
    end

    def save_locale_to_cookie
      cookies['locale'] = I18n.locale.to_s
    end

    def get_user_locale
        current_user.locale if user_signed_in?
    end

    def sanitize_locale(locale)
      locale.to_s if I18n.available_locales.map(&:to_s).include? locale.to_s
    end
end
