module Devise
  module Strategies
    class TemporarySignin < Base
      def authenticate!
        signin = TemporarySigninQuery
                 .confirmation_token(params['confirmation_token'])

        if signin
          RedeemTemporarySignin.for(signin)
          success!(signin.user)
        else
          fail(:not_found_in_database)
        end
      end

      def valid?
        params['confirmation_token']
      end
    end
  end
end
