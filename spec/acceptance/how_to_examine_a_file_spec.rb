require "spec_helper"

describe "printing the rate of change of one file" do
  include FileUtils

  before do
    given_a_git_repo_at ".tmp"
    cd ".tmp"
  end

  after { cd ".." }

  it "lists each revision" do
    result = %x{ ../bin/nosy_git README }
    result.must =~ /Jazz\'s bike seat$/
    result.must =~ /Phil\'s lunch box$/
  end

  private

  def given_a_git_repo_at path
    Git.create_at path
  end
end
