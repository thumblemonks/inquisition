class Animal
  attr_accessor :name, :noise

  def initialize(attributes)
    attributes.each_pair do |k,v|
      self.send(:"#{k}=",v) 
    end
  end

  def bark
    "#{noise.capitalize}! #{noise.capitalize}!"
  end
end
