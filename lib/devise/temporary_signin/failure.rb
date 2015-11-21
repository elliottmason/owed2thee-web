module Devise
  module TemporarySignin
    class Failure < Devise::FailureApp
      def respond
        if warden_options[:recall] && params['confirmation_token']
          return self.status = 403
        else
          super
        end
      end
    end
  end
end
