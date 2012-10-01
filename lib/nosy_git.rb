Dir.glob("#{File.dirname(__FILE__)}/nosy_git/**/*.rb").each {|f| require f }

class NosyGit
  def initialize(file)
    @file = file
    @file_constraints = Constraints.new @file do |c|
      c.when_valid   { analyze_core }
      c.when_invalid { |reason| abort reason }
    end
    @ui = Pretty.new file
  end
  
  def analyze; @file_constraints.apply; end

  private

  def analyze_core
    Revisions.for(@file).each do |rev|
      @ui.print RevisionText.print @file, rev 
    end
  end

  def abort(why); @ui.die why; end
end
