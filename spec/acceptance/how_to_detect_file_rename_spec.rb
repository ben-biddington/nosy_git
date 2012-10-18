require "spec_helper"
require File.join File.dirname(__FILE__), "nosy_git_acceptance_test"

describe "detecting file renames using `git diff`" do
  include NosyGitAcceptanceTest

  it "can get the new name of a file when HEAD is a pure rename" do
    %x{ 
      git mv README "README RENAMED"
      git commit -m "Renamed the README"
    }
    
    result = Rename.for("README", "HEAD").must === "README RENAMED"
  end

  it "can get the new name for any commit, i.e., a commit that is not the current HEAD" do
    new_name = "README RENAMED"

    `echo "#1" >> README         && git commit -am "COMMIT #1"`
    `git mv README "#{new_name}" && git commit -am "COMMIT #2 (RENAME)"`
    `echo "#3" >> "#{new_name}"  && git commit -am "COMMIT #3"`

    Rename.for("README", "HEAD^").must === new_name
  end

  it "if the commit is not a rename it returns nil" do
    `echo "#1" >> README && git commit -am "COMMIT #1"`
    `echo "#2" >> README && git commit -am "COMMIT #2"`
    
    Rename.for("README", "HEAD^").must be_nil
  end

  it "can get the new name for a commit that is a rename AND a change" do
    %x{ 
      echo "#1" >> README && git commit -am "COMMIT #1"
      echo "Changing the readme and renaming in one commit" > README
      git mv README "README RENAMED"
      git commit -m "Renamed the README, and added some text"
    }
    
    result = Rename.for("README", "HEAD").must === "README RENAMED"
  end
end
