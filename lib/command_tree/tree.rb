require 'io/console'
require 'colorize'
require 'colorized_string'

module CommandTree
  # A tree of commands and associated keys for every node
  class Tree
    def initialize
      @calls = { '' => {} }
    end

    # register a `path` to a `name` with a block of code if
    # you wish it to be a command, the following `options` are
    # supported:
    # desc: a description of the item, as a help text for the user
    def register(path, name, options = {}, &block)
      insure_path(path, name, options)
      return unless block_given?

      calls[path] = { name: name, options: options, block: block }
    end

    # define a group of commands (subtree)
    # the method will create a subtree and pass it to
    # the given block of code if you passed a block
    # otherwise it works in a similar way to register
    def group(prefix, name, options = {})
      subtree = self.class.new
      yield(subtree) if block_given?

      merge(subtree, prefix, name, options)
    end

    # Start the tree, prints the first level and walk
    # the user through the tree with keystroks
    def show
      execute_path('')
    end

    # merge a subtree with a prefix and a name
    def merge(subtree, prefix, name, options = {})
      register(prefix, name, options)
      subtree.calls.each do |key, command|
        next if key.empty?

        calls["#{prefix}#{key}"] = command
      end
    end

    protected

    attr_accessor :calls

    private

    def insure_path(path, name, options = {})
      return if path.empty?

      insure_path(path[0...-1], name, options)
      calls[path] = { name: name, options: options } unless calls[path]
    end

    def execute_path(path)
      return puts "#{path} couldn't be found..." unless calls.key?(path)

      node = calls[path]
      children = calls.keys.select do |key|
        key.start_with?(path) && key.length == (path.length + 1)
      end
      children.sort!

      puts "#{node[:name]}:".light_magenta.bold if node.key?(:name)

      description = node.dig(:options, :desc)
      puts description.to_s.light_black if description

      node[:block].call if node.key?(:block)

      return if children.empty?

      print_children(children)
      choice = STDIN.getch
      execute_path(path + choice)
    end

    def print_children(children)
      table_content = []

      children.each do |child|
        child_node = calls[child]

        output = child[-1].green
        output << ' → '.light_black

        output << if child_node.key?(:block)
                    " #{child_node[:name].ljust(40)}".cyan
                  else
                    "+#{child_node[:name].ljust(40)}".light_magenta.bold
                  end

        table_content << output
      end

      table(table_content, 40)
      print "\n"
    end

    def table(items, item_width)
      _, screen_width = IO.console.winsize
      items_per_row = screen_width / item_width
      items_dup = items.dup

      puts items_dup.shift(items_per_row).join until items_dup.empty?
    end
  end
end
