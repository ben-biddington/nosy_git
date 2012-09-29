class RevisionText
  def self.print(the_file, rev)
    the_number_of_lines = Lines.for the_file, rev.number

    msg = rev.message.length > 50 ? "#{rev.message[0,50]}..." : rev.message

    "author:#{rev.author.ljust(25)}, " + 
    "#{rev.timestamp} #{rev.number}, " + 
    "lines: #{the_number_of_lines.to_s.ljust(10)}, " + 
    "added: #{rev.changes.added.to_s.ljust(10)}, " + 
    "message: #{msg}"
  end
end
