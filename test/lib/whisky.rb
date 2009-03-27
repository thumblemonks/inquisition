class Whisky
  attr_accessor :name, :origin, :abv, :description
  cleanse_attr :name, :description

  def initialize(attributes)
    attributes.each_pair do |k,v|
      self.send(:"#{k}=",v) 
    end
  end

  def drink
    "You quaffed #{description}"
  end
end
