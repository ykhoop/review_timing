module ApplicationHelper
  require 'securerandom'

  def page_title(page_title = '')
    base_title = t('defaults.app_name')

    page_title.empty? ? base_title : page_title + ' - ' + base_title
  end

  def background_image_class_random()
    random_number = SecureRandom.random_number(3) + 1
    return "background-image-#{random_number}"
  end
end
