# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'waft/version'

Gem::Specification.new do |spec|
  spec.name          = "waft"
  spec.version       = Waft::VERSION
  spec.authors       = ["dayflower"]
  spec.email         = ["daydream.trippers@gmail.com"]

  spec.summary       = %q{waft - 2FA password manager}
  spec.description   = %q{waft - 2FA password manager}
  spec.homepage      = "https://github.com/dayflower/waft"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = %w[
    Gemfile
    LICENSE.txt
    README.md
    Rakefile
    bin/console
    bin/setup
    exe/waft-shell
    exe/waft-web
    lib/waft.rb
    lib/waft/cli/shell.rb
    lib/waft/entity.rb
    lib/waft/repository.rb
    lib/waft/service.rb
    lib/waft/util.rb
    lib/waft/version.rb
    lib/waft/web.rb
    static/index.html
    static/model.js
    static/tags.tag
    test/test_helper.rb
    test/waft_test.rb
    waft.gemspec
  ]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rotp", "~> 3.3"
  spec.add_dependency "rqrcode", "~> 0.10"
  spec.add_dependency "highline", "~> 1.7"
  spec.add_dependency "rack", "~> 1.6"
  spec.add_dependency "rack-router", "~> 0.6"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
