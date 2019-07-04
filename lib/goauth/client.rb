# frozen_string_literal: true

require 'faraday'
require 'json'

require_relative 'batch'

module Goauth
  class Client
    def initialize(base_url, api_key)
      @base_url = base_url
      @api_key = api_key
    end

    def authenticate!(credentials)
      post('/auth', { email: credentials[:email], password: credentials[:password] }, @api_key)
    end

    def create_account(account)
      hash = post('/accounts', account, @api_key)
      Account.new(hash)
    end

    def register_account(account)
      hash = post('/register', account, @api_key)
      Account.new(hash)
    end

    def delete_account(id)
      delete("/accounts/#{id}", @api_key)
    end

    def update_account(id, account)
      put("/accounts/#{id}", account, @api_key)
    end

    def accounts(page: 1)
      rs = get('/accounts', @api_key, page: page)
      ResultList.new(rs, Account)
    end

    def find_account(id)
      hash = get(File.join('/accounts', id), @api_key)
      Account.new(hash)
    end

    def generate_password_recovery_token(account_id)
      payload = {
        'accountId' => account_id,
        'validTime' => nil
      }
      post('/custom-password-recovery-token', payload, @api_key)
    end

    def password_check(account_id, password)
      payload = {
        'accountId' => account_id,
        'password' => password
      }
      rs = post('/password-check', payload, @api_key)
      rs[:correct]
    end

    # changes password _after_ obtaining a token
    def change_password(token, password)
      payload = {
        'token' => token,
        'newPassword' => password,
        'newPasswordRetype' => password, # TODO: I hope this will go away
        'loginAfter' => false
      }
      post('/password-recovery-set', payload, @api_key)
    end

    def batch(&block)
      b = BatchOperations.new
      block.yield(b)
      payload = b.ops.map do |e|
        { method: e[0],
          url: e[1],
          body: e[2] }
      end
      rs = post('/batch-update', payload, @api_key)
      rs.zip(b.ops).map do |response, op|
        case response[:status]
        when 'SUCCESS'
          op[3].call(JSON.parse(response[:body], symbolize_names: true))
        else
          AuthError.new
        end
      end
    end

    private

    def get(url, api_key, params = {})
      response = conn.get url, params do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['app-key'] = api_key
      end
      case response.status
      when 200..299
        JSON.parse(response.body, symbolize_names: true)
      else
        fail AuthError, JSON.parse(response.body, symbolize_names: true)
      end
    end

    def post(url, account, api_key)
      request_with_body(url, account, api_key, method: :post)
    end

    def put(url, account, api_key)
      request_with_body(url, account, api_key, method: :put)
    end

    def request_with_body(url, account, api_key, method:)
      response = conn.public_send(method, url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['app-key'] = api_key
        req.body = account.to_json
      end
      case response.status
      when 200..299
        JSON.parse(response.body, symbolize_names: true)
      else
        fail AuthError, JSON.parse(response.body, symbolize_names: true)
      end
    end

    def delete(url, api_key)
      response = conn.delete url do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['app-key'] = api_key
      end
      case response.status
      when 200..299
        JSON.parse(response.body, symbolize_names: true)
      else
        fail AuthError, JSON.parse(response.body, symbolize_names: true)
      end
    end

    def conn
      @conn ||= Faraday.new(@base_url) do |b|
        b.adapter :net_http
      end
    end
  end
end
