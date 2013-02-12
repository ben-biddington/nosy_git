require "spec_helper"
require File.join File.dirname(__FILE__), "..", "git_acceptance_test"

describe "The greatest hits report" do
  include GitAcceptanceTest

  before do
    vanilla
  end

  it "shows the top 5 longest files"
  it "shows the top 5 most edited files (files with the most commits)"
end
