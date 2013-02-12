require File.join File.dirname(__FILE__), "git_acceptance_test"

module NosyGitAcceptanceTest
  include GitAcceptanceTest
  
  def self.included klass
    klass.class_eval do
      before do
        vanilla
      end

      after { cd ".." }
    end
  end

  def nosy_git file
    self.result = %x{ ../bin/nosy_git #{file} }
    self.exitstatus = $?.exitstatus
  end
  
  def commit_a_readme
    %x{ touch README }
    %x{ git add -A }
    %x{ git commit -m "First commit" }
  end
end
