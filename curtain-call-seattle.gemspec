
# lib = File.expand_path("../lib", __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "curtain-call-seattle/version"

Gem::Specification.new do |spec|
  spec.name          = "curtain-call-seattle"
  spec.version       = CurtainCallSeattle::VERSION
  spec.authors       = ["Annette Michaels"]
  spec.email         = ["micha232@umn.edu"]

  spec.summary       = "Theater in Seattle"
  spec.description   = "Aggregates plays and musicals from the various theaters in Seattle"
  spec.homepage      = "https://github.com/Rygel-XVI/curtain-call-seattle-cli-gem.git"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end
  spec.bindir        = "bin"
  spec.executables   = "curtain-call"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
end
