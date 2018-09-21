# CommandTree [![Gem Version](https://badge.fury.io/rb/command_tree.svg)](https://badge.fury.io/rb/command_tree)

Builds trees of commands for the terminal, each node is either a group of commands or the command itself, every node is associated with a character to access it.

[![asciicast](https://asciinema.org/a/202202.png)](https://asciinema.org/a/202202)
The previous Asciinema script is here: https://gist.github.com/emad-elsaid/b259894caa9a78863b582ecc7a31811a

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'command_tree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install command_tree

## Usage

You start by creating a new tree

```ruby
t = CommandTree::Tree.new
```

Then you can register a command category (a node that contains commands)

```ruby
t.register 'a', 'Applications' # associate the character 'a' to a category called 'applications'
```

Then register commands inside that prefix
```ruby
t.register 'ag','Google Chrome' do
  system 'google-chrome-stable'
end
```
the previous block will be assigned to 'g' inside 'a' which is the application's prefix, so you can execute it with 'ag' when you run that tree in terminal.

To run the tree call `#show`
```ruby
t.show
```

it will print the toplevel categories and commands and wait for you to press a character to execute the command or print sub commands of a category node.

when the tree reachs a leaf it'll exit, if a command is the leaf it will execute it and exit the tree giving your code the control again.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/emad-elsaid/command_tree.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
