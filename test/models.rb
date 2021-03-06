ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => File.join(File.dirname(__FILE__), 'test.db')
 
class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :whiskies, :force => true do |t|
      t.string :name, :origin, :description, :measure
      t.integer :abv
    end
    create_table :animals, :force => true do |t|
      t.string :name, :noise
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Animal < ActiveRecord::Base
  sanitize_attribute :name

  def bark
    "#{noise.capitalize}! #{noise.capitalize}!"
  end
end

class Whisky < ActiveRecord::Base
  sanitize_attribute :name, :description, :measure, :allow => { :description => "&", :measure => /(<buttes>)/ }

  def drink
    "You quaffed #{description}"
  end
end
