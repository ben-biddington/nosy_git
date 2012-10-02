class Lines
  class << self
    def for(file, revision)
      begin
        # git diff-tree -r -c -M -C --no-commit-id #{revision}
        # find the sha1 for the required file
        %x{ git checkout #{revision} #{file} }
        %x{ wc -l #{file} }.match(/^([^\s]+) /)[1].to_i
      ensure
        Revisions.head file
      end
    end
  end
end
