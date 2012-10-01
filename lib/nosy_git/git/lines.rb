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
