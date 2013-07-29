class Rails::Boot 
  def run 
    load_initializer 
    extend_environment 
    Rails::Initializer.run(:set_load_path) 
  end 

  def extend_environment 
    Rails::Initializer.class_eval do 
      old_load = instance_method(:load_environment) 
      define_method(:load_environment) do 
        Bundler.require :default, Rails.env 
        old_load.bind(self).call 
      end 
    end 
  end 
end
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
