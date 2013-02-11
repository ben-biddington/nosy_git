class Pretty
  def initialize(file)
    @file = file
    print_header
  end
  
  def print(revision)
    msg = revision.message.length > 50 ? "#{revision.message[0,50]}..." : revision.message

    UI.print "author:#{revision.author.ljust(25)}, " + 
      "#{revision.timestamp} #{revision.number}, " + 
      "lines: #{revision.line_count.to_s.ljust(10)}, " + 
      "added: #{revision.changes.added.to_s.ljust(10)}, " + 
      "deleted: #{revision.changes.deleted.to_s.ljust(10)}, " + 
      "change: #{revision.changes.net_added.to_s.ljust(10)}, " + 
      "message: #{msg}"
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

class CSV
  def initialize(file)
    @file = file
    print_header
  end

  def print(revision)
    UI.print( 
      "#{revision.timestamp}," + 
      "#{revision.changes.added}," + 
      "#{revision.changes.deleted}," + 
      "#{revision.changes.net_added}"
    )
  end

  def die(because)
    UI.die because
  end

  private

  def print_header
    UI.print "timestamp,added,deleted,change"
  end
end

class UI
  class << self
    def die(because)
      print because
      exit 1
    end
    def print what; puts what; end
  end
end

