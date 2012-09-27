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
    result.must =~ /Jazz\'s bike seat/
    result.must =~ /Phil\'s lunch box/
  end

  it "with each revision, it prints the number of lines in the file" do
    5.times{ %x{ echo `date` >> README } }
    %x{ git commit -am "COMMIT #1" }
    5.times{ %x{ echo `date` >> README } }
    %x{ git commit -am "COMMIT #2" }

    result = nosy_git "README"
    result.must =~ /lines: 5, message: COMMIT #1/
    result.must =~ /lines: 10, message: COMMIT #2/
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

  it "fails to start if there are any changes"
  it "lists lines added and deleted for each revision"

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
