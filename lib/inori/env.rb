# frozen_string_literal: true

##
# Add env method to Ironi root module
module Inori
  # @return [String] inori environment
  def self.env
    ENV['INORI_ENV'].to_sym || :development
  end
end

##
# meta-programming symbol for env validation
class Symbol
  # @return [TrueClass | FalseClass] if string is equal to production
  def production?
    self == :production
  end

  # @return [TrueClass | FalseClass] if string is equal to development
  def development?
    self == :development
  end
end
