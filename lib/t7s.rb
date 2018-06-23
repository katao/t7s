require 'active_support/all'
require 'yaml'
require 'hashie'
require "t7s/version"
require "t7s/idol"
require "t7s/idol/name"

module T7s
  def self.method_missing(name, *args)
    if T7s::Idol.valid?(name)
      T7s::Idol.find_by_name(name)
    else
      T7s::Idol.send(name, *args)
    end
  rescue NoMethodError
    super
  end
end
