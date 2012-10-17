require "spec_helper"
require File.join File.dirname(__FILE__), "nosy_git_acceptance_test"

describe "displaying the revision history of a file" do
  include NosyGitAcceptanceTest
  
  it "prints the working directory" do
    nosy_git "README"
    then_it_shows /\(#{Regexp.escape(pwd)}\)$/
  end

  it "lists each revision" do
    %x{ echo `date` >> README }
    %x{ git commit -am "Jazz's bike seat" }
    %x{ echo `date` >> README }
    %x{ git commit -am "Phil's lunch box" }

    nosy_git "README"
    then_it_shows /Jazz\'s bike seat/
    then_it_shows /Phil\'s lunch box/
  end

  it "with each revision, it prints the number of lines in the file" do
    5.times{ %x{ echo `date` >> README } }
    %x{ git commit -am "COMMIT #1" }
    5.times{ %x{ echo `date` >> README } }
    %x{ git commit -am "COMMIT #2" }

    nosy_git "README"

    then_it_shows /lines: 5.+message: COMMIT #1/
    then_it_shows /lines: 10.+message: COMMIT #2/
  end

  it "lists the date and time of each revision" do
    today = Time.now
    %x{ echo "Another kebab on a weekday" >> README }
    %x{ git commit -am "Jazz's bike seat" }

    expected_date_string = Time.now.strftime "%a %b %d"

    nosy_git "README"
    then_it_shows /#{expected_date_string}/
  end

  it "resets to the head revision at the end!" do
    head_revision_contents = "TWO"
    neck_revision_contents = "ONE"

    %x{ echo #{neck_revision_contents} >> README}
    %x{ git commit -am "COMMIT #1" }
    %x{ echo #{head_revision_contents} >> README}
    %x{ git commit -am "COMMIT #2" }

    nosy_git "README"

    the_file_contents = `cat README`

    the_file_contents.must =~ /#{head_revision_contents}/
    the_file_contents.must =~ /#{neck_revision_contents}/

    Git.must_not have_changes
  end

  it "lists the user that made each revision" do
    Git.user = "Ben Rules"
    %x{ echo `date` >> README }
    %x{ git commit -am "Rob's Mum" }    
    
    Git.user = "Whack Jackson"
    %x{ echo `date` >> README }
    %x{ git commit -am "Graeme's Face" }    

    nosy_git "README"

    then_it_shows /Ben Rules.+Rob's Mum/
    then_it_shows /Whack Jackson.+Graeme's Face/
  end

  it "includes commits across file renames" do
    %x{ echo `date` >> README }
    %x{ git commit -am "COMMIT #1 on original README" }
    %x{ echo `date` >> README }
    %x{ git commit -am "COMMIT #2 on original README" }
    %x{ mv README README_RENAMED }
    %x{ git add -A }
    %x{ git commit -m "Renamed file" }
    
    nosy_git "README_RENAMED"
    
    then_it_shows /COMMIT #1 on original README/
    then_it_shows /COMMIT #2 on original README/
    then_it_shows /Renamed file/
  end

  it "files before the rename cannot have their \"lines added collected\", and so they come through as zero" do
    pending "This is because we're running `git log -- <RENAMED_FILE>` and so the old file name does not register"
  end

  it "if you check out a file at a revision where it does not exist it does nothing -- meaning you get head. 
  Need to check with `git s` to see if the co had any affect"

# This happens during renames -- you can't check out a file when it does not exist

end

