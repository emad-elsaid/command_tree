
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "command_tree/version"

Gem::Specification.new do |spec|
  spec.name          = "command_tree"
  spec.version       = CommandTree::VERSION
  spec.authors       = ["Emad Elsaid"]
  spec.email         = ["emad.elsaid@blacklane.com"]

  spec.summary       = %q{Command trees for the terminal}
  spec.description   = %q{Builds trees of commands for the terminal, each node is either a group of commands or the command itself, every node is associated with a character to access it.}
  spec.homepage      = "https://www.github.com/emad-elsaid/command_tree"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize", "~> 0.8"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
