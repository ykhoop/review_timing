module I18n
  class << self
    def ln(object, **options)
      object.presence && l(object, **options)
    end
  end
end
