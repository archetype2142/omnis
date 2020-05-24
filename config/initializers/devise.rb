Devise.setup do |config|
  # Required so users don't lose their carts when they need to confirm.
  config.allow_unconfirmed_access_for = 1.days

  # Fixes the bug where Confirmation errors result in a broken page.
  config.router_name = :spree

  # Add any other devise configurations here, as they will override the defaults provided by spree_auth_devise.
  config.secret_key = "682d1e664dfaf29d4d9f3348e9d754927e571dcd3f55f904c4085e412670b3e49ec9c49d612593727d36b34be739be121a1b"
end