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
end
