# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paybox_money/version'

Gem::Specification.new do |spec|
  spec.name          = "paybox_money"
  spec.version       = PayboxMoney::VERSION
  spec.authors       = ["Pavel Tkachenko", "Ilya Timchenko"]
  spec.email         = ["tpepost@gmail.com", "skiny66.ilya@gmail.com"]

  spec.summary       = %q{Wrapper for paybox.money API}
  spec.description   = %q{Wrapper for payments and cashouts for paybox.money API}
  spec.homepage      = "https://github.com/PavelTkachenko/paybox_money"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
