require 'io/console'
require 'colorize'
require 'colorized_string'

module CommandTree
  class Tree
    def initialize
      @calls = { '' => {} }
    end

    def register(path, name, options = {}, &block)
      insure_path(path, name, options)
      calls[path] = { name: name, options: options, block: block } if block_given?
    end

    def show
      execute_path('')
    end

    private

    attr_accessor :calls

    def insure_path(path, name, options = {})
      return if path.empty?

      insure_path(path[0...-1], name, options)
      calls[path] = { name: name, options: options } unless calls[path]
    end

    def execute_path(path)
      return puts "#{path} couldn't be found..." unless calls.key?(path)

      node = calls[path]
      children = calls.keys.select { |key| key.start_with?(path) && key.length == (path.length + 1) }
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
      print "\n\n"
    end

    def table(items, item_width)
      _, width = IO.console.winsize
      items_per_row = width / item_width
      items.each_with_index do |item, index|
        print item
        print "\n" if ((index + 1) % items_per_row).zero? && index > 0
      end
    end
  end
end
