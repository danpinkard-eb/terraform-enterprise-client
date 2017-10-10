# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require File.expand_path('../lib/terraform_enterprise_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'terraform_enterprise_api'
  gem.authors       = [ "Maciej Skierkowski" ]
  gem.email         = ''
  gem.homepage      = 'http://github.com/skierkowski/terraform_enterprise_api'
  gem.summary       = 'Ruby client for the official Terraform Enterprise API'
  gem.description   = %q{ Ruby client that supports all of the Terraform Enterprise API methods. }
  gem.version       = TerraformEnterprise::VERSION
  gem.required_ruby_version = '>= 2.3.1'

  gem.files = Dir['{lib}/**/*']
  gem.require_paths = %w[ lib ]
  gem.extra_rdoc_files = ['LICENSE.txt', 'README.md']

  gem.add_dependency 'rest-client', '~> 2.0.2'
  gem.add_dependency 'json', '~> 2.1.0'
end