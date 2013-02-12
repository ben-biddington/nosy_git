class Options
  require 'optparse'

  def initialize(args)
    @format = Pretty

    OptionParser.new do |opts|
      opts.on("-f", "--format FORMAT", "The output format (defaults to pretty)") do |format|
          @format = CSV if format == "csv"
      end
    end.parse(args)
  end

  def ui; @format; end
end
