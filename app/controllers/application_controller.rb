class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format.json? }

  around_filter :with_timezone
  before_action :set_locale

  protected

  def set_locale
    if params_locale = sanitize_locale(params[:locale])
      I18n.locale = params_locale
      save_locale_to_user
      save_locale_to_cookie
    elsif user_signed_in? && current_user.locale
      I18n.locale = current_user.locale
      save_locale_to_cookie
    elsif cookie_locale = sanitize_locale(cookies['locale'])
      I18n.locale = cookie_locale
      save_locale_to_user
    else
      require 'http_accept_language_parser.rb'
      parser = HttpAcceptLanguage::Parser.new(env["HTTP_ACCEPT_LANGUAGE"])
      I18n.locale = parser.compatible_language_from(I18n.available_locales)
      save_locale_to_cookie
      save_locale_to_user
    end
  end

  def save_locale_to_user
    return unless user_signed_in?
    user = User.find(current_user.id)
    user.locale = I18n.locale
    user.save
  end

  def save_locale_to_cookie
    cookies['locale'] = I18n.locale.to_s
  end

  def sanitize_locale(locale)
    locale.to_s if I18n.available_locales.map(&:to_s).include? locale.to_s
  end

  def with_timezone
    timezone = Time.find_zone(cookies[:timezone])
    Time.use_zone(timezone) { yield }
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to hello_path
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end
end
