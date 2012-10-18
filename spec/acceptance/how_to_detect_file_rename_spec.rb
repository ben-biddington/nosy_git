require "spec_helper"
require File.join File.dirname(__FILE__), "nosy_git_acceptance_test"

class Renamed
  class << self
    def for(file, revision)
      result = `git diff-index -M HEAD^`
      match = result.match /#{file}\s+(.+)$/
      the_new_name = match[1] if match
      the_new_name
    end
  end
end

describe "detecting file renames using `git diff-index`" do
  include NosyGitAcceptanceTest

  it "can get the new name of a file when HEAD is a pure rename" do
    %x{ 
      git mv README "README RENAMED"
      git commit -m "Renamed the README"
    }
    
    result = Renamed.for "README", "HEAD"
    
    result.must === "README RENAMED"
  end
end
