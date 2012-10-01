class Constraints
  def self.apply_to(file)
    UI.die "You have changes, aborting."       if Git.has_changes?
    UI.die "No file supplied, aborting."       if file.nil? or file.empty?
    UI.die "File not found, aborting."       unless File.exists? file
    UI.die "#{file} is not a file, aborting."  unless File.file? file
  end
end
