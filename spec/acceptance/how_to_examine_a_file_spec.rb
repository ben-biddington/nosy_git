require "spec_helper"
require File.join File.dirname(__FILE__), "nosy_git_acceptance_test"

describe "printing the rate of change of one file" do
  include NosyGitAcceptanceTest
  
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
    result.must =~ /Jazz\'s bike seat/
    result.must =~ /Phil\'s lunch box/
  end

  it "with each revision, it prints the number of lines in the file" do
    5.times{ %x{ echo `date` >> README } }
    %x{ git commit -am "COMMIT #1" }
    5.times{ %x{ echo `date` >> README } }
    %x{ git commit -am "COMMIT #2" }

    result = nosy_git "README"
    result.must =~ /lines: 5.+message: COMMIT #1/
    result.must =~ /lines: 10.+message: COMMIT #2/
  end

  it "lists the date and time of each revision" do
    today = Time.now
    %x{ echo "Another kebab on a weekday" >> README }
    %x{ git commit -am "Jazz's bike seat" }

    expected_date_string = Time.now.strftime "%a %b %d"

    result = nosy_git "README"
    result.must =~ /#{expected_date_string}/
  end

  it "resets to the head revision at the end!" do
    head_revision_contents = "TWO"
    neck_revision_contents = "ONE"

    %x{ echo #{neck_revision_contents} >> README}
    %x{ git commit -am "COMMIT #1" }
    %x{ echo #{head_revision_contents} >> README}
    %x{ git commit -am "COMMIT #2" }

    result = nosy_git "README"

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

    result = nosy_git "README"

    result.must =~ /Ben Rules.+Rob's Mum/
    result.must =~ /Whack Jackson.+Graeme's Face/
  end

  it "exits with status 1 if there are any changes" do
    %x{ echo `date` >> README }
    %x{ git commit -am "Jazz's bike seat" }
    %x{ echo "Any staged change" >> README }
    %x{ git commit -am "This one has been staged" }
    %x{ echo "Any working tree change" >> README }

    result = nosy_git "README"

    result.must =~ /aborting/
    $?.exitstatus.must === 1
  end

  it "exits with status 1 if the argument is not a file" do
    dirname = "a_directory"
    `mkdir #{dirname}`
    `touch #{dirname}/.gitkeep`
    `git add -A && git commit -m "Commiting a dir"`
    
    result = nosy_git "#{dirname}"

    result.must =~ /#{dirname} is not a file/
    $?.exitstatus.must === 1
  end

  it "exits with status 1 if the argument is missing" do
    result = nosy_git nil

    result.must =~ /No file/
    $?.exitstatus.must === 1
  end

  it "lists lines added for each revision" do
    %x{ echo `date` >> README }
    %x{ git commit -am "COMMIT #1" }
    %x{ echo `date` >> README }
    %x{ git commit -am "COMMIT #2" }
    result = nosy_git "README"

    result.must =~ /added: 1.+COMMIT #2/
  end

  it "lists lines added for the first revision" do
    cd ".."
    given_a_git_repo_at ".tmp"
    cd ".tmp"

    expected_lines_added=7

    expected_lines_added.times{%x{ echo `date` >> README }}
    %x{ git add -A && git commit -am "COMMIT #1" }

    result = nosy_git "README"

    result.must =~ /added: #{expected_lines_added}.+COMMIT #1/
  end

  it "only includes lines added for the file in question" do
    3.times{`echo "xxx" >> another_file.rb`}
    `git add another_file.rb`

    %x{ echo `date` >> README }
    %x{ git commit -am "COMMIT #1" }

    result = nosy_git "README"

    result.must =~ /added: 1.+COMMIT #1/
  end

  it "includes commits across file renames" do
    %x{ echo `date` >> README }
    %x{ git commit -am "COMMIT #1 on original README" }
    %x{ echo `date` >> README }
    %x{ git commit -am "COMMIT #2 on original README" }
    %x{ mv README README_RENAMED }
    %x{ git add -A }
    %x{ git commit -m "Renamed file" }
    
    result = nosy_git "README_RENAMED"
    
    result.must =~ /COMMIT #1 on original README/
    result.must =~ /COMMIT #2 on original README/
    result.must =~ /Renamed file/
  end

  it "files before the rename cannot have their \"lines added collected\", and so they come through as zero" do
    pending "This is because we're running `git log -- <RENAMED_FILE>` and so the old file name does not register"
  end
end
