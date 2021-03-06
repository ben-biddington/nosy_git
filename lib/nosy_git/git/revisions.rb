Revision = Struct.new(:file, :timestamp, :number, :message, :author, :changes) do
  def line_count
    @line_count ||= Lines.for(file, number)
  end
end

Changes  = Struct.new(:added, :deleted) do
  def net_added
    added-deleted
  end
end

class Revisions
  class << self
    def for(file)
      log_entries_for(file).map{|line| to_revision file, line }
    end

    def head(file)
      fail "Not resetting without a file" if file.empty?
      
      `git reset HEAD #{file}`
      `git checkout #{file}`
    end

    private

    def log_entries_for file
      %x{ git log --format="%ct %H auth='%an' %s" --follow -- #{file} }
    end

    def to_revision(file, line)
      matches = line.match /([^\s]+)\s([^\s]+)\sauth='([^\"]+)'\s(.+)/

      the_timestamp       = Time.at matches[1].strip.to_i
      the_revision        = matches[2].strip
      the_author          = matches[3].strip
      the_commit_message  = matches[4].strip
      
      Revision.new(
        file,           
        the_timestamp, 
        the_revision, 
        the_commit_message, 
        the_author, 
        changes(file, the_revision)
      )
    end

    def changes(file, revision)
      return Changes.new Lines.for(file, revision),0 unless has_parent? revision 
      
      matches = `git diff --numstat #{revision}^..#{revision} -- #{file}`.match /^([\d]+)\s+([\d]+)/

      return Changes.new(0,0) unless matches

      Changes.new matches[1].strip.to_i, matches[2].strip.to_i
    end

    def has_parent?(revision)
      `git cat-file -p #{revision}`.match /^parent/
    end
  end
end
