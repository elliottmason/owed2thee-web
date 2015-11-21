module Devise
  module TemporarySignin
    class Strategy < Devise::Strategies::Base
      def authenticate!
        signin = TemporarySigninQuery
                 .confirmation_token(params['confirmation_token'])

        return fail!(:unauthenticated) unless signin

        RedeemTemporarySignin.for(signin)
        success!(signin.user)
      end

      def valid?
        params['confirmation_token']
      end
    end
  end
end
