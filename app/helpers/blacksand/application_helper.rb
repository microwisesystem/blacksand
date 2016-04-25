module Blacksand
  module ApplicationHelper

    def paginate objects, options = {}
      options.reverse_merge!(theme: 'twitter-bootstrap-3')

      super(objects, options)
    end

    def page(en_name)
      Page.where(en_name: en_name).first
    end

    def textarea2html(text)
      text.split(' ').join('<br>').html_safe if text.present?
    end

    def filed_options(f)
      filed_options = {}
      case f.object.field.field_type
        when 'date' then
          filed_options = {data: {provide: 'datepicker', 'date-format' => 'yyyy-mm-dd', 'date-language' => 'zh-CN', 'date-autoclose' => true}}
        when 'gallery' then
          filed_options = {multiple: true}
      end
      return filed_options.merge({label: "#{f.object.field.description}", label_class: "#{'required' if f.object.field.required?}"})
    end

    def set_page_options(hash)
      @_page_options ||= {}
      @_page_options.merge!(hash)
    end

    def page_options
      @_page_options || {}
    end

  end
end
