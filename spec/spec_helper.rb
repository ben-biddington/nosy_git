$:.unshift './bin'

Dir.glob("./lib/nosy_git/**/*.rb").each {|f| require f }
Dir.glob("./spec/acceptance/lib/**/*.rb").each {|f| require f}

require 'rspec'

Object.class_eval do
  alias :must     :should
  alias :must_not :should_not
end
