class CSV
  def initialize(file)
    @file = file
    print_header
  end

  def print(revision)
    UI.print( 
      "\"#{revision.timestamp}\"," + 
      "#{revision.changes.added}," + 
      "#{revision.changes.deleted}," + 
      "#{revision.changes.net_added}," +
      "#{revision.line_count}"
    )
  end

  def die(because)
    UI.die because
  end

  private

  def print_header
    UI.print "timestamp,added,deleted,change,line_count"
  end
end
