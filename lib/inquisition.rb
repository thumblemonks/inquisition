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

  def self.sanitize(value, allow)
    if allow && match = Regexp.new(allow).match(value)
      [HTML5libSanitize.sanitize_html(match.pre_match), match.to_a.first, self.sanitize(match.post_match, allow)].join
    else
      HTML5libSanitize.sanitize_html(value)
    end
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
        write_inheritable_attribute(:cleansed_attr_reader_options, cleansed_attr_reader_options.merge(options))
      else
        write_inheritable_attribute(:cleansed_attr_readers, attributes)
        write_inheritable_attribute(:cleansed_attr_reader_options, options)
        class_inheritable_reader(:cleansed_attr_readers)
        class_inheritable_reader(:cleansed_attr_reader_options)

        define_method(:read_attribute_with_cleansing) do |attribute|
          value = read_attribute_without_cleansing(attribute)
          if cleansed_attr_readers.include?(attribute.to_sym) && !value.blank?
            Inquisition.sanitize(value,
              cleansed_attr_reader_options[:allow] ? cleansed_attr_reader_options[:allow][attribute.to_sym] : nil)
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
        write_inheritable_attribute(:cleansed_attr_writer_options, cleansed_attr_writer_options.merge(options))
      else
        write_inheritable_attribute(:cleansed_attr_writers, attributes)
        write_inheritable_attribute(:cleansed_attr_writer_options, options)
        class_inheritable_reader(:cleansed_attr_writers)
        class_inheritable_reader(:cleansed_attr_writer_options)

        define_method(:write_attribute_with_cleansing) do |attribute, value|
          if cleansed_attr_writers.include?(attribute.to_sym) && !value.blank?
            Inquisition.sanitize(value,
              cleansed_attr_writer_options[:allow] ? cleansed_attr_writer_options[:allow][attribute.to_sym] : nil)
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
