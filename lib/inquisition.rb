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
      options = attributes.last.is_a?(::Hash) ? attributes.pop : {}
      if respond_to?(:cleansed_attr_readers)
        write_inheritable_attribute(:cleansed_attr_readers, cleansed_attr_readers.concat(attributes))
      else
        write_inheritable_attribute(:cleansed_attr_readers, attributes)
        class_inheritable_reader(:cleansed_attr_readers)

        define_method(:read_attribute_with_cleansing) do |attribute|
          value = read_attribute_without_cleansing(attribute)
          if cleansed_attr_readers.include?(attribute.to_sym) && !value.blank?
            if allow = options[:allow][attribute.to_sym]
              value = value.split(allow.blank? ? " " : allow)
              value = value.map do |partial|
                HTML5libSanitize.sanitize_html(partial)
              end.join(allow)
            else
              HTML5libSanitize.sanitize_html(value)
            end
          else
            value
          end
        end
        alias_method_chain :read_attribute, :cleansing
      end

      attributes.each { |attr| define_method(attr.to_sym) { read_attribute(attr.to_sym) } }
    end

    def sanitize_attribute_writer(*attributes)
      options = attributes.last.is_a?(::Hash) ? attributes.pop : {}
      if respond_to?(:cleansed_attr_writers)
        write_inheritable_attribute(:cleansed_attr_writers, cleansed_attr_writers.concat(attributes))
      else
        write_inheritable_attribute(:cleansed_attr_writers, attributes)
        class_inheritable_reader(:cleansed_attr_writers)

        define_method(:write_attribute_with_cleansing) do |attribute, value|
          if cleansed_attr_writers.include?(attribute.to_sym) && !value.blank?
            if allow = options[:allow][attribute.to_sym]
              value = value.split(allow.blank? ? " " : allow)
              value = value.map do |partial|
                HTML5libSanitize.sanitize_html(partial)
              end.join(allow)
            else
              HTML5libSanitize.sanitize_html(value)
            end
          end

          write_attribute_without_cleansing(attribute, value)
        end
        alias_method_chain :write_attribute, :cleansing
      end
    end
  end #Class Methods
end #Inquisition

class Object
  include Inquisition
end
