module Devise
  module TemporarySignin
    class Failure < Devise::FailureApp
      def respond
        return redirect \
          if warden_options[:recall] && params['confirmation_token']
        super
      end
    end
  end
end
