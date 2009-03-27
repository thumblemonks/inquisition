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

    # cleanse_attr creates getters and setters for the specified list of attributes.
    def cleanse_attr(*attributes)
      cleanse_attr_reader(*attributes)
      cleanse_attr_writer(*attributes)
    end

    def cleanse_attr_reader(*attributes)
      attributes.each do |attr|
        alias_method(:"#{attr}_without_cleansing", :"#{attr}")
        define_method(:"#{attr}") do
          HTML5libSanitize.new.sanitize_html(send(:"#{attr}_without_cleansing"))
        end
      end
    end

    def cleanse_attr_writer(*attributes)
      attributes.each do |attr|
        alias_method(:"#{attr}_without_cleansing=", :"#{attr}=")
        define_method(:"#{attr}=") do |value|
          send(:"#{attr}_without_cleansing=", HTML5libSanitize.new.sanitize_html(value))
        end
      end
    end
  end #Class Methods
end #Inquisition

class Object
  include Inquisition
end
