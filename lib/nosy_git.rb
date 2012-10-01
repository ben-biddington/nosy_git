Dir.glob("#{File.dirname(__FILE__)}/nosy_git/**/*.rb").each {|f| require f }

class NosyGit
  def initialize(file)
    @file = file
  end
  
  def analyze
    apply_constraints
  end

  private

  def apply_constraints
    file_constraints = Constraints.new @file
    
    file_constraints.when_valid do
      header
      body
    end
    
    file_constraints.when_invalid do |reason|
      abort reason
    end

    file_constraints.apply
  end

  def header
    require 'fileutils'
    
    UI.print "(#{FileUtils.pwd})"
    UI.print "Analyzing <#{@file}>"
  end

  def body
    Revisions.for(@file).each do |rev|
      UI.print RevisionText.print @file, rev 
    end
  end

  def abort(why)
    UI.die why
  end
end
