class SignInForm < BaseForm
  def self.from(resource)
    @resource = resource.clone
    @resource.class_eval do
      attr_reader :email
    end
    @resource
  end
end
