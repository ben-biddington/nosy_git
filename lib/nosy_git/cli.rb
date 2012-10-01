class Pretty
  def initialize(file)
    @file = file
    print_header
  end
  
  def print(what)
    UI.print what
  end

  def die(because)
    UI.die because
  end

  private

  def print_header
    require 'fileutils'
    
    UI.print "(#{FileUtils.pwd})"
    UI.print "Analyzing <#{@file}>"
  end
end
