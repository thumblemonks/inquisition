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
      options = attributes.last.is_a?(Hash) ? attributes.pop : {}
      attributes.each do |attr|
        alias_method(:"#{attr}_without_cleansing", :"#{attr}")
        define_method(:"#{attr}") do
          HTML5libSanitize.new.sanitize_html(send(:"#{attr}_without_cleansing"))
        end
      end
    end
  end
end

class Object
  include Inquisition
end
