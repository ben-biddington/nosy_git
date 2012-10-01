require "spec_helper"
require File.join File.dirname(__FILE__), "nosy_git_acceptance_test"

describe "constraints" do
  include NosyGitAcceptanceTest

  it "aborts if there are any changes" do
    %x{ 
      echo `date` >> README 
      git commit -am "Jazz's bike seat"
     
      echo "Any staged change" >> README 
      git commit -am "This one has been staged" 
      echo "Any working tree change" >> README 
    }

    nosy_git "README"

    then_it_aborts_because /You have changes/
  end

  it "aborts if the argument is not a file" do
    dirname = "a_directory"
    `mkdir #{dirname}`
    `touch #{dirname}/.gitkeep`
    `git add -A && git commit -m "Commiting a dir"`
    
    nosy_git "#{dirname}"

    then_it_aborts_because /#{dirname} is not a file/
  end

  it "aborts if the argument is missing" do
    nosy_git nil
    then_it_aborts_because /No file/
  end

  it "aborts if the argument is a file that does not exist" do
    nosy_git "xxx_any_file_that_does_not_exist_xxx"
    then_it_aborts_because /File not found/
  end
end
