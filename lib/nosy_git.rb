Dir.glob("#{File.dirname(__FILE__)}/nosy_git/**/*.rb").each {|f| require f }

class NosyGit
  def initialize(file)
    @file = file
  end
  
  def analyze
    verify
    header
    body
  end

  private

  def header
    require 'fileutils'
    
    UI.print "(#{FileUtils.pwd})"
    UI.print "Analyzing <#{@file}>"
  end

  def verify
    Constraints.apply_to @file
  end

  def body
    Revisions.for(@file).each do |rev|
      UI.print RevisionText.print @file, rev 
    end
  end
end
