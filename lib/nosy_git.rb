class Lines
  class << self
    def for(file, revision)
      %x{ git checkout #{revision} #{file} }
      %x{ wc -l #{file} }.match(/^([^\s]+) /)[1]
    end
  end
end

Revision = Struct.new(:number, :message)

class Revisions
  class << self
    def for(file)
      stdout = %x{ git log --oneline -- #{file} }
      stdout.map do |line|
        matches = line.match /([^\s]+)\s(.+)/

        the_revision       = matches[1].strip
        the_commit_message = matches[2].strip
        
        Revision.new(the_revision, the_commit_message)
      end
    end
  end
end
