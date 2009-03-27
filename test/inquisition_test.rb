require 'test_helper'

class InquisitionTest < Test::Unit::TestCase
  context "a fine Whisky" do
    setup do
      @whisky = Whisky.new(:name => "<script>alert('Cragganmore')</script>", :origin => 'Scotland', :abv => 42.0,
        :description => %Q['';!--"<XSS>=&{()}a buttery scotch])
    end

    should "have heresy removed from name" do
      assert_equal "&lt;script&gt;alert('Cragganmore')&lt;/script&gt;", @whisky.name
    end
  end
end
