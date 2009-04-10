module Inquisition
  module Shoulda
    def should_sanitize_attributes(*attributes)
      should_sanitize_attribute_readers(*attributes)
      should_sanitize_attribute_writers(*attributes)
    end

    def should_sanitize_attribute_writers(*attributes)
      attribute_value = "<script>alert('howdy');</script>"
      klass = model_class
      attributes.each do |attribute|
        should "sanitize writer values for #{attribute}" do
          object = get_instance_of(klass)
          object.instance_variable_set(:@attributes, attribute.to_s => "")
          HTML5libSanitize.expects(:sanitize_html).once.with(attribute_value)
          object.send(:"#{attribute}=", attribute_value)
        end
      end
    end

    def should_sanitize_attribute_readers(*attributes)
      attribute_value = "<script>alert('howdy');</script>"
      klass = model_class

      attributes.each do |attribute|
        should "sanitize reader values for #{attribute}" do
          object = get_instance_of(klass)
          object.instance_variable_set(:@attributes, attribute.to_s => attribute_value)
          HTML5libSanitize.expects(:sanitize_html).once.with(attribute_value)
          object.send(attribute.to_sym)
        end
      end
    end

  end #Shoulda
end #Inquisition

Test::Unit::TestCase.extend(Inquisition::Shoulda)
