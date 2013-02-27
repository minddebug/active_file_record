# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_file_record/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Vitaliy.L"]
  gem.email         = ["lacour.vv@gmail.com"]
  gem.description   = %q{Gem description}
  gem.summary       = %q{Gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "active_file_record"
  gem.require_paths = ["lib"]
  gem.version       = ActiveFileRecord::VERSION
end
