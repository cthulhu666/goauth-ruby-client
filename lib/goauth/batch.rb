# frozen_string_literal: true

module Goauth
  class BatchOperations
    attr_reader :ops

    def initialize
      @ops = []
    end

    def create_account(account)
      @ops << ['POST', '/accounts', account, ->(e) { Account.new(e) }]
      true
    end

    def delete_account(id)
      @ops << ['DELETE', "/accounts/#{id}", nil, ->(_e) { nil }]
      true
    end

    def update_account(id, account)
      @ops << ['PUT', "/accounts/#{id}", account, ->(e) { Account.new(e) }]
      true
    end
  end
end
