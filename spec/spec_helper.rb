$:.unshift './bin'

require 'rspec'

Object.class_eval do
  alias :must     :should
  alias :must_not :should_not
end
