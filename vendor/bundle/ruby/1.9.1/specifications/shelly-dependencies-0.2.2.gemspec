# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "shelly-dependencies"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Shelly Cloud team"]
  s.date = "2013-03-11"
  s.description = "Loads gems required for deployment on Shelly Cloud"
  s.email = ["support@shellycloud.com"]
  s.homepage = "https://shellycloud.com"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Shelly Cloud deployment dependencies"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<thin>, [">= 0"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<thin>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<thin>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
