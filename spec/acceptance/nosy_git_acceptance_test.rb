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

  attr_accessor :result

  def nosy_git file
    #NosyGit.analyze file
    result = %x{ ../bin/nosy_git #{file} }
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
