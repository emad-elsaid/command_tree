module CommandTree
  # A group of commands
  class Group
    attr_reader :name, :desc, :prefix

    def initialize(prefix, name, options = {})
      @prefix = prefix
      @name = name
      @desc = options[:desc]
    end

    def execute
      print_banner
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
