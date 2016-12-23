module Goauth
  class ResultList
    attr_reader :items, :pagination

    def initialize(json, klass)
      @items = json[:items].map { |e| klass.new(e) }.freeze
      @pagination = json[:paging].freeze
    end
  end
end
