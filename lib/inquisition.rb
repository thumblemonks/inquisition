require 'html5'
require 'html5lib_sanitize'

# == Introduction
# 
# Inquisition will escape html included in specified attributes to
# eliminate xss-style attacks.
module Inquisition
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def cleanse_attr(*attributes)
      cleanse_attr_reader(*attributes)
      cleanse_attr_writer(*attributes)
    end

    def cleanse_attr_reader(*attributes)
      attributes.each do |attr|
        define_method(:"#{attr}") do
          HTML5libSanitize.sanitize_html(read_attribute(attr.to_sym))
        end
      end
    end

    def cleanse_attr_writer(*attributes)
      attributes.each do |attr|
        define_method(:"#{attr}=") do |value|
          write_attribute(attr.to_sym, HTML5libSanitize.sanitize_html(value))
        end
      end
    end
  end #Class Methods
end #Inquisition

class Object
  include Inquisition
end
