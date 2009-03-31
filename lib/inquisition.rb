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
      write_inheritable_attribute(:cleansed_attr_readers, attributes)
      class_inheritable_reader(:cleansed_attr_readers)

      define_method(:read_attribute_with_cleansing) do |attribute|
        if cleansed_attr_readers.include?(attribute.to_sym)
          HTML5libSanitize.sanitize_html(read_attribute_without_cleansing(attribute))
        else
          read_attribute_without_cleansing(attribute)
        end
      end
      alias_method_chain :read_attribute, :cleansing
    end

    def cleanse_attr_writer(*attributes)
      write_inheritable_attribute(:cleansed_attr_writers, attributes)
      class_inheritable_reader(:cleansed_attr_writers)

      define_method(:write_attribute_with_cleansing) do |attribute, value|
        if cleansed_attr_writers.include?(attribute.to_sym)
          write_attribute_without_cleansing(attribute, HTML5libSanitize.sanitize_html(value))
        else
          write_attribute_without_cleansing(attribute, value)
        end
      end
      alias_method_chain :write_attribute, :cleansing
    end
  end #Class Methods
end #Inquisition

class Object
  include Inquisition
end
