module Devise
  module TemporarySignin
    class Strategy < Devise::Strategies::Base
      def authenticate!
        signin = begin
                   TemporarySigninQuery.
                 confirmation_token!(params['confirmation_token'])
                 rescue ActiveRecord::RecordNotFound
                   return fail!(:unauthenticated)
                 end

        RedeemTemporarySignin.for(signin)
        success!(signin.user)
      end

      def valid?
        params['confirmation_token']
      end
    end
  end
end
