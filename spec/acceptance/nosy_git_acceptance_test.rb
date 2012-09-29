module NosyGitAcceptanceTest
  include FileUtils
  
  def self.included klass
    klass.class_eval do
      before do
        given_a_git_repo_at ".tmp"
        cd ".tmp"
        commit_a_readme
      end

      after { cd ".." }
    end
  end

  protected

  def then_it_aborts_because(reason)
    then_it_shows reason
    exitstatus.must === 1
  end

  def then_it_shows(message)
    fail "there is no result to assert on" unless result
    message = /^message$/ unless message.is_a? Regexp
    result.must =~ message
  end

  attr_accessor :result, :exitstatus

  def nosy_git file
    self.result = %x{ ../bin/nosy_git #{file} }
    self.exitstatus = $?.exitstatus
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
