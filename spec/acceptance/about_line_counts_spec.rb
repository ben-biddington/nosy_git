require "spec_helper"
require File.join File.dirname(__FILE__), "nosy_git_acceptance_test"

describe "the line counts it returns" do
  include NosyGitAcceptanceTest

  it "lists (net) lines added for each revision" do
    five_lines = <<-EOF
      line 1
      line 2
      line 3
      line 4
      line 5
    EOF
    
    %x{ echo "#{five_lines}" > README }
    %x{ git commit -am "COMMIT #1 (contains 5 lines)" }
    
    one_deleted_three_added = <<-EOF
      line 1
      line 2
      line 3
      line 4
      line 6
      line 7
      line 8
    EOF

    %x{ echo "#{one_deleted_three_added}" > README }
    %x{ git commit -am "COMMIT #2" }
    
    expected_net_added = 3-1

    result = nosy_git "README"

    then_it_shows /added: #{expected_net_added}.+COMMIT #2/
  end

  it "lists lines added for the first revision" do
    cd ".."
    given_a_git_repo_at ".tmp"
    cd ".tmp"

    expected_lines_added=7

    expected_lines_added.times{%x{ echo `date` >> README }}
    %x{ git add -A && git commit -am "COMMIT #1" }

    nosy_git "README"

    then_it_shows /added: #{expected_lines_added}.+COMMIT #1/
  end

  it "only includes lines added for the file in question" do
    3.times{`echo "xxx" >> another_file.rb`}
    `git add another_file.rb`

    %x{ echo `date` >> README }
    %x{ git commit -am "COMMIT #1" }

    nosy_git "README"

    then_it_shows /added: 1.+COMMIT #1/
  end
end
