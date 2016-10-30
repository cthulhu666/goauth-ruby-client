require 'hashie'

module Goauth
  class Account < Hashie::Dash
    include Hashie::Extensions::Dash::PropertyTranslation

    property :id
    property :status
    property :first_name, from: :firstName
    property :last_name, from: :lastName
    property :emails

  end
end
