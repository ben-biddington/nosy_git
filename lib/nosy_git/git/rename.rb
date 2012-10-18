class Rename
  class << self
    def for(file, revision)
      result = `git diff -M #{revision}^..#{revision}`

      match = result.match /rename to\s+(.+)$/i
      the_new_name = match[1] if match
      the_new_name
    end
  end
end
