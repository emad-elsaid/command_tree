module CommandTree
  # A command class
  class Command
    attr_reader :name, :desc, :prefix, :block

    def initialize(prefix, name, options = {}, &block)
      @prefix = prefix
      @name = name
      @desc = options[:desc]
      @block = block
    end

    def execute
      print_banner
      block.call
    end

    private

    def print_banner
      puts pretty_name if name
      puts pretty_description if desc
    end

    def pretty_name
      name.light_magenta.bold if name
    end

    def pretty_description
      desc.to_s.light_black if desc
    end
  end
end
