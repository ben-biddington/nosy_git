class Lines
  class << self
    def for(file, revision)
      begin
        the_blob = find_blob(file, revision)
        
        return 0 unless the_blob

        `git cat-file -p #{the_blob} | wc -l`.match(/^([^\s]+)/)[1].to_i
      ensure
        Revisions.head file
      end
    end

    private

    def find_blob(file, revision)
      result = `git ls-tree -r #{revision} -- #{file}`.match /blob (\w+)\s+/
      result ? result[1] : nil
    end
  end
end
