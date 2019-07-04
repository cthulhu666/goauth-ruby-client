# frozen_string_literal: true

require 'spec_helper'

describe Goauth::Client, :vcr do
  let(:client) do
    described_class.new('https://goauth.intami.pl',
                        ENV.fetch('API_KEY', 'some.fake.key'))
  end

  describe '#create_account' do
    it 'works' do
      client.create_account(firstName: 'foo', lastName: 'bar', emails: [{ email: 'foo@bar.baz' }])
    end
  end

  describe '#accounts' do
    let(:accounts) { client.accounts }
    it 'works' do
      expect(accounts).to be_a Goauth::ResultList
    end
  end

  describe '#batch' do
    context 'without errors' do
      it 'works' do
        rs = client.batch do |b|
          b.create_account(firstName: 'foo1', lastName: 'bar1', emails: [{ email: 'xfoo1@bar.baz' }])
          b.create_account(firstName: 'foo2', lastName: 'bar2', emails: [{ email: 'xfoo2@bar.baz' }])
        end
        expect(rs.length).to eq(2)
        expect(rs[0]).to be_a(Goauth::Account)
        expect(rs[1]).to be_a(Goauth::Account)
      end
    end

    context 'with errors' do
      it 'works' do
        rs = client.batch do |b|
          b.create_account(firstName: 'foo1', lastName: 'bar1', emails: [{ email: 'xboo1@bar.baz' }])
          b.create_account(firstName: 'foo2', lastName: 'bar2', emails: [{ email: 'xboo1@bar.baz' }])
        end
        expect(rs.length).to eq(2)
        expect(rs[0]).to be_a(Goauth::Account)
        expect(rs[1]).to be_a(Goauth::AuthError)
      end
    end
  end
end
