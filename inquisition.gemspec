# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{inquisition}
  s.version = "0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["toothrot"]
  s.date = %q{2009-07-06}
  s.email = %q{scissorjammer@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["VERSION.yml", "README.rdoc", "lib/inquisition.rb", "lib/html5lib_sanitize.rb", "test/inquisition_test.rb", "test/performance.rb", "test/models.rb", "test/test_helper.rb", "Rakefile", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/thumblemonks/inquisition}
  s.post_install_message = %q{Choosy heretics choose Thumble Monks.}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Inquisition is a fancy way to protect your ActiveRecord attributes from XSS}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q{html5}, [">= 0.10.0"])
    else
      s.add_dependency(%q{html5}, [">= 0.10.0"])
    end
  else
    s.add_dependency(%q{html5}, [">= 0.10.0"])
  end
end
