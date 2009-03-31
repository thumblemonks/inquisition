require 'test_helper'

class InquisitionTest < Test::Unit::TestCase
  context "a fine Whisky" do
    setup do
      @whisky = Whisky.new(:name => "<script>alert('Cragganmore')</script>", 
        :origin => "<SCRIPT SRC=http://ha.ckers.org/xss.js>Scotland</SCRIPT>", :abv => 42,
        :description => %Q['';!--"<XSS>=&{()}a buttery scotch])
    end

    should "have heresy removed from name" do
      assert_equal "&lt;script&gt;alert('Cragganmore')&lt;/script&gt;", @whisky.name
    end

    should "remove already-ingrained heresey" do
      @whisky.instance_variable_set(:@name, "<script>alert('Cragganmore')</script>")
      assert_equal "&lt;script&gt;alert('Cragganmore')&lt;/script&gt;", @whisky.name
    end

    should "cleanse heresy before setting" do
      @whisky.name = "<script>alert('Cragganmore')</script>"
      private_name = @whisky.attributes["name"]

      assert_equal "&lt;script&gt;alert('Cragganmore')&lt;/script&gt;", private_name
    end

    should "not cleanse fields not targeted for cleansing" do
      assert_equal "<SCRIPT SRC=http://ha.ckers.org/xss.js>Scotland</SCRIPT>", @whisky.origin
    end

    should "not cleanse and set fields not targeted for cleansing" do
      @whisky.origin = "<SCRIPT SRC=http://ha.ckers.org/xss.js>Scotland</SCRIPT>"
      private_origin = @whisky.attributes["origin"]
      assert_equal "<SCRIPT SRC=http://ha.ckers.org/xss.js>Scotland</SCRIPT>", @whisky.origin
    end
  end
end
