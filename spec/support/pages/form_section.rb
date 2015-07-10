module FormSection
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def form_section(name, field_prefix: nil, fields: [], selector: nil)
      field_prefix ||= name
      selector ||= "##{name}"

      section_klass = Class.new(FormSection) do
        fields.each do |field|
          element :"#{field}_field", "##{field_prefix}_#{field}"
        end
        element :submit_button, 'input[type="submit"]'
      end

      section :"#{name}_form", section_klass, selector
    end
  end

  class FormSection < SitePrism::Section
    def submit(params = {})
      params.each do |key, value|
        send(:"#{key}_field").set(value)
      end
      submit_button.click
    end
  end
end
