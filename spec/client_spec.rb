# frozen_string_literal: true
require 'spec_helper'

describe Goauth::Client, :vcr do
  let(:client) do
    described_class.new('http://auth.go.intami.pl',
                        'some.fake.key')
  end
  it 'works' do
    client.create_account(firstName: 'foo', lastName: 'bar', emails: [{ email: 'foo@bar.baz' }])
  end
end
