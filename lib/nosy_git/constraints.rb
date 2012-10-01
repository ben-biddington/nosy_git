class Constraints
  def initialize(file, &block)
    @file = file
    @passed = true
    
    yield self if block_given?
  end
  
  def when_invalid &_then
    fail_listeners << _then
  end

  def when_valid &_then
    okay_listeners << _then
  end

  def apply
    must_not_have_changes
    must_supply_a_file
    okay_otherwise
  end

  private
  
  def must_not_have_changes
    die "You have changes, aborting."       if Git.has_changes?
  end

  def must_supply_a_file
    die "No file supplied, aborting."       if @file.nil? or @file.empty?
    die "File not found, aborting."         unless File.exists? @file
    die "#{@file} is not a file, aborting."  unless File.file? @file
  end

  def die(reason)
    @passed = false
    fail_listeners.each {|listener| listener.call(reason)}
  end

  def okay_otherwise
    okay_listeners.each {|listener| listener.call} if @passed
  end
    
  def fail_listeners; @fail_listeners ||= []; end 
  def okay_listeners; @okay_listeners ||= []; end 
end
