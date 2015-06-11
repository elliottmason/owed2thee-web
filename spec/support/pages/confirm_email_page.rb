class ConfirmEmailPage < SitePrism::Page
  set_url '/account/emails{/email}/confirm{/confirmation_token}'
end
