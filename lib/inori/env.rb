# frozen_string_literal: true

module Inori
  # @return [String] inori environment
  def self.env
    ENV['INORI_ENV'] || 'development'
  end
end

class String
  # @return [TrueClass | FalseClass] if string is equal to production
  def production?
    self == 'production'
  end

  # @return [TrueClass | FalseClass] if string is equal to development
  def development?
    self == 'development'
  end
end
