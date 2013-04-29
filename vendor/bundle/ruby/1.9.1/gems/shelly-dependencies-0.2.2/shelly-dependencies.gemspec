# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "shelly-dependencies"
  s.version     = "0.2.2"
  s.authors     = ["Shelly Cloud team"]
  s.email       = ["support@shellycloud.com"]
  s.homepage    = "https://shellycloud.com"
  s.summary     = %q{Shelly Cloud deployment dependencies}
  s.description = %q{Loads gems required for deployment on Shelly Cloud}

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"

  s.add_runtime_dependency "thin"
  s.add_runtime_dependency "rake"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

