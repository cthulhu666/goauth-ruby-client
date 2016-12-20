# frozen_string_literal: true
require 'faraday'
require 'json'

module Goauth
  class Client
    def initialize(base_url, api_key)
      @base_url = base_url
      @api_key = api_key
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

    def accounts(page: 1)
      get('/accounts', @api_key, page: page)
    end

    def find_account(id)
      hash = get(File.join('/accounts', id), @api_key)
      Account.new(hash)
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
      response = conn.post url do |req|
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
