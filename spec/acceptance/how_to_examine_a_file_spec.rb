require "spec_helper"

describe "printing the rate of change of one file" do
  include FileUtils

  before do
    given_a_git_repo_at ".tmp"
    cd ".tmp"
  end

  after { cd ".." }

  it "lists each revision" do
    %x{ touch README }
    %x{ echo `date` >> README }
    %x{ git add -A }
    %x{ git commit -m "Jazz's bike seat" }
    %x{ echo `date` >> README }
    %x{ git commit -am "Phil's lunch box" }

    result = %x{ ../bin/nosy_git README }
    result.must =~ /Jazz\'s bike seat$/
    result.must =~ /Phil\'s lunch box$/
  end

  private

  def given_a_git_repo_at path
    Git.create_at path
  end
end
