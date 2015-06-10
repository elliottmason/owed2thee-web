module FormSection
  def self.included(base)
    base.class_eval do
      element :submit_button, 'input[type="submit"]'
    end
  end

  def submit(params = {})
    params.each do |key, value|
      send(:"#{key}_field").set(value)
    end
    submit_button.click
  end
end
