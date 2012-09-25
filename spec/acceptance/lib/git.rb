class Git
  extend FileUtils

  class << self
    def create_at path
      current_dir = pwd
      rm_r path if File.exists? path
      mkdir path
      cd path
      %x{ git init }
      %x{ touch README }
      %x{ echo `date` >> README }
      %x{ git add -A }
      %x{ git commit -m "Jazz's bike seat" }
      %x{ echo `date` >> README }
      %x{ git commit -am "Phil's lunch box" }
      cd current_dir
    end
  end
end
