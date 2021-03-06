class Options
  def initialize(args)
    @format = Pretty

    require 'optparse'

    OptionParser.new do |opts|
      opts.on("-f", "--format FORMAT", "The output format (defaults to pretty)") do |format|
          @format = CSV if format == "csv"
      end
    end.parse(args)
  end

  def ui; @format; end
end
