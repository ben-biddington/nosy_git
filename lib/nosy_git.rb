class Lines
  class << self
    def for(file, revision)
      %x{ git checkout #{revision} #{file} }
      %x{ wc -l #{file} }.match(/^([^\s]+) /)[1]
    end
  end
end

Revision = Struct.new(:timestamp, :number, :message, :author)

class Revisions
  class << self
    def for(file)
      stdout = %x{ git log --format="%ct %H auth='%an' %s" -- #{file} }
      stdout.map do |line|
        matches = line.match /([^\s]+)\s([^\s]+)\sauth='([^\"]+)'\s(.+)/

        the_timestamp       = Time.at matches[1].strip.to_i
        the_revision        = matches[2].strip
        the_author          = matches[3].strip
        the_commit_message  = matches[4].strip

        Revision.new(the_timestamp, the_revision, the_commit_message, the_author)
      end
    end

    def head(file)
      fail "Not resetting without a file" if file.empty?
      
      `git reset HEAD #{file}`
      `git checkout #{file}`
    end
  end
end
