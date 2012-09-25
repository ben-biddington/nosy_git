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
    
    private
    
    def clobber path
      rm_r path if File.exists? path
      mkdir path
    end
  end
end
