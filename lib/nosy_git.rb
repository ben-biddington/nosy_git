Dir.glob("#{File.dirname(__FILE__)}/nosy_git/**/*.rb").each {|f| require f }

class NosyGit
  class << self
    def analyze file
      verify file
      header file 

      Revisions.for(file).each do |rev|
        UI.print RevisionText.print file, rev 
      end
    end

    private

    def header(file)
      require 'fileutils'

      UI.print "(#{FileUtils.pwd})"
      UI.print "Analyzing <#{file}>"
    end

    def verify(file)
      UI.die "You have changes, aborting."       if Git.has_changes?
      UI.die "No file supplied, aborting."       if file.nil? or file.empty?
      UI.die "#{file} is not a file, aborting."  unless File.file? file
    end
  end
end
