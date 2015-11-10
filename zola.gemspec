lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zola/version'

Gem::Specification.new do |spec|
  spec.name          = "zola"
  spec.version       = Zola::VERSION
  spec.authors       = ["Oduola Akeem"]
  spec.email         = ["akeem.oduola@andela.com"]

  spec.summary       = %q{ Zola is an encryption engine for encrypting, decrypting, and cracking messages.}
  spec.homepage      = "https://github.com/andela-aoduola/zola"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "wdm", "~> 0.1.1"
  spec.add_development_dependency "coveralls"
end
