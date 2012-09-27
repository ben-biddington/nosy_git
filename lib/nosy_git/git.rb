class Git
  extend FileUtils

  class << self
    def create_at path
      current_dir = pwd
      
      clobber path
      
      cd path
      %x{ git init }
      
      cd current_dir
    end

    def user=(name)
      fail "Can't use empty name" if name.empty?
      `git config user.name "#{name}"`
    end

    def has_changes?; !all_clean?; end
    
    private
    
    def all_clean?
      `git status` =~ /nothing to commit/
    end

    def clobber path
      rm_r path if File.exists? path
      mkdir path
    end
  end
end
