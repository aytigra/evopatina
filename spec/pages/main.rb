

# define sections used on multiple pages or multiple times on one page

class HeaderSection < SitePrism::Section
  element :user_name, "#user_name"
end

class FlashSection < SitePrism::Section
  element :msg, ".alert>span"
end

class SectorsSection < SitePrism::Section
  elements :names, "div span"
end

class MainPage < SitePrism::Page
  set_url '/'
  set_url_matcher /\//

  section :header, HeaderSection, ".navbar"
  section :flash, FlashSection, "#flash"
  section :sectors, SectorsSection, "#sectors"
end

class LoginPage < SitePrism::Page
  set_url '/users/sign_in'
  set_url_matcher /\/users\/sign_in/


  element :email, "#user_email"
  element :password, "#user_password"
  element :button, "input[type='submit']"
end