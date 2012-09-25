require "spec_helper"

describe "printing the rate of change of one file" do
  include FileUtils

  before do
    given_a_git_repo_at ".tmp"
    cd ".tmp"
    commit_a_readme
  end

  after { cd ".." }

  it "prints the working directory" do
    result = nosy_git "README"
    result.must =~ /\(#{Regexp.escape(pwd)}\)$/
  end

  it "lists each revision" do
    %x{ echo `date` >> README }
    %x{ git commit -am "Jazz's bike seat" }
    %x{ echo `date` >> README }
    %x{ git commit -am "Phil's lunch box" }

    result = nosy_git "README"
    result.must =~ /Jazz\'s bike seat$/
    result.must =~ /Phil\'s lunch box$/
  end

  private

  def nosy_git file
    %x{ ../bin/nosy_git #{file} }
  end
  
  def given_a_git_repo_at path
    Git.create_at path
  end

  def commit_a_readme
    %x{ touch README }
    %x{ git add -A }
    %x{ git commit -m "First commit" }
  end
end
