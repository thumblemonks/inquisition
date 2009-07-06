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
    def sanitize_attribute(*attributes)
      sanitize_attribute_reader(*attributes)
      sanitize_attribute_writer(*attributes)
    end

    def sanitize_attribute_reader(*attributes)
      write_inheritable_attribute(:cleansed_attr_readers, attributes)
      class_inheritable_reader(:cleansed_attr_readers)

      define_method(:read_attribute_with_cleansing) do |attribute|
        value = read_attribute_without_cleansing(attribute)
        if cleansed_attr_readers.include?(attribute.to_sym) && !value.blank?
          HTML5libSanitize.sanitize_html(value)
        else
          value
        end
      end
      alias_method_chain :read_attribute, :cleansing

      attributes.each { |attr| define_method(attr.to_sym) { read_attribute(attr.to_sym) } }
    end

    def sanitize_attribute_writer(*attributes)
      write_inheritable_attribute(:cleansed_attr_writers, attributes)
      class_inheritable_reader(:cleansed_attr_writers)

      define_method(:write_attribute_with_cleansing) do |attribute, value|
        if cleansed_attr_writers.include?(attribute.to_sym) && !value.blank?
          value = HTML5libSanitize.sanitize_html(value)
        end

        write_attribute_without_cleansing(attribute, value)
      end
      alias_method_chain :write_attribute, :cleansing
    end
  end #Class Methods
end #Inquisition

class Object
  include Inquisition
end
