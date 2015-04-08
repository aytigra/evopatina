class NavbarSection < SitePrism::Section
  element :user_name, "#user_name"
end

class FlashSection < SitePrism::Section
  element :msg, ".alert>span"
end

class SectorsSection < SitePrism::Section
  elements :names, "div span"
end

class WeekTabsSection < SitePrism::Section
  element :show_current, "#weeks-current-tab a"
  element :show_list, "#weeks-list-tab a"
end

class WeeksContentSection < SitePrism::Section
  class CurrentWeekSection < SitePrism::Section
    class LapaFormSection < SitePrism::Section
      elements :inputs, "input[name^='week']"
      element :submit, "input[type='submit']"
    end

    element :prev_link, "#prev-week-link"
    element :next_link, "#next-week-link"
    element :week_dates, "#week-dates"
    elements :progress, "div.progress div div"

    element :lapa_form_btn, "button.lapa-settings"
    section :lapa_form, LapaFormSection, "div[id^=lapa_form]"
  end

  class WeeksListSection < SitePrism::Section
    elements :week_links, "a"
  end

  section :current, CurrentWeekSection, "#week-current"
  section :list, WeeksListSection, "#weeks-list"
end

class MainPage < SitePrism::Page
  set_url '/'
  set_url_matcher /\//

  section :navbar, NavbarSection, ".navbar"
  section :flash, FlashSection, "#flash"
  section :sectors, SectorsSection, "#sectors"
  section :weeks_tabs, WeekTabsSection, "#week-action-toggle"
  section :content, WeeksContentSection, "#week-action-content"
end

class LoginPage < SitePrism::Page
  set_url '/users/sign_in'
  set_url_matcher /\/users\/sign_in/


  element :email, "#user_email"
  element :password, "#user_password"
  element :button, "input[type='submit']"
end