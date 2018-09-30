require 'colorize'
require 'colorized_string'

module CommandTree
  # responsible for showing the menu in terminal
  class TextMenu
    def initialize(item_width)
      @item_width = item_width
      @items = []
    end

    def render
      _, screen_width = IO.console.winsize
      items_per_row = screen_width / item_width

      names = items.dup.map! { |item| item_name(item) }
      descs = items.dup.map! { |item| item_desc(item) }

      until names.empty?
        puts names.shift(items_per_row).join
        row_descs = descs.shift(items_per_row).join
        puts row_descs unless row_descs.strip.empty?
      end
    end

    def add(item)
      items << item
    end

    private

    attr_reader :items, :item_width

    def  item_name(item)
      prefix = item.prefix
      arrow = ' → '

      name_width = item_width - prefix.length - arrow.length
      name =  (item.is_a?(Group) ? '+' : '') + item.name
      name = name.ljust(name_width)

      colored_name = item.is_a?(Group) ? name.light_magenta.bold : name.cyan

      (prefix.green + arrow.light_black + colored_name)
    end

    def item_desc(item)
      desc = item.desc.to_s
      return desc.ljust(item_width) if desc.strip.empty?

      return (desc[0...item_width - 3] + '...').light_black if desc.length >= item_width
      return desc.ljust(item_width).light_black
    end
  end
end
