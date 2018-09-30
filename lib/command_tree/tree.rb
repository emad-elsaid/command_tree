require 'io/console'

require_relative 'group'
require_relative 'command'
require_relative 'text_menu'

module CommandTree
  # A tree of commands and associated keys for every node
  class Tree
    def initialize
      @calls = { '' => nil }
    end

    # register a `path` to a `name` with a block of code if
    # you wish it to be a command, the following `options` are
    # supported:
    # desc: a description of the item, as a help text for the user
    def register(path, name, options = {}, &block)
      path = path.to_s
      name = name.to_s
      prefix = path[-1]

      insure_path(path, name, options)
      return unless block_given?

      calls[path] = Command.new(prefix, name, options, &block)
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
        next unless command

        calls["#{prefix}#{key}"] = command
      end
    end

    protected

    attr_accessor :calls

    private

    def insure_path(path, name, options = {})
      return if path.empty?

      insure_path(path[0...-1], name, options)
      calls[path] = Group.new(path[-1], name, options) unless calls[path]
    end

    def execute_path(path)
      return puts "#{path} couldn't be found..." unless calls.key?(path)

      node = calls[path]
      node.execute if node

      children = get_children(path)
      return if children.empty?

      print_children(children)
      choice = STDIN.getch
      execute_path(path + choice)
    end

    def get_children(path)
      calls.keys.select do |key|
        key.start_with?(path) && key.length == (path.length + 1)
      end.sort
    end

    def print_children(children)
      menu = TextMenu.new(40)

      children.each do |child|
        menu.add calls[child]
      end

      menu.render
      print "\n"
    end
  end
end
