Dir.glob("#{File.dirname(__FILE__)}/nosy_git/**/*.rb").each {|f| require f }

class NosyGit
  class << self
    def analyze file
      Revisions.for(file).each do |rev|
        puts RevisionText.print file, rev 
      end
    end
  end
end

class Lines
  class << self
    def for(file, revision)
      begin
        %x{ git checkout #{revision} #{file} }
        %x{ wc -l #{file} }.match(/^([^\s]+) /)[1]
      ensure
        Revisions.head file
      end
    end
  end
end
