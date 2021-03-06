require File.join(File.dirname(__FILE__), 'test_helper')

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
      @whisky.instance_variable_set(:@attributes, "name" => "<script>alert('Cragganmore')</script>")
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

    should "not show pain for setting blank attributes" do
      @whisky.origin = nil
      @whisky.name = nil
      assert_equal nil, @whisky.origin
      assert_equal nil, @whisky.name
    end

    should "not show pain for getting blank attributes" do
      @whisky.update_attributes(:origin => nil, :name => nil)
      assert_equal nil, @whisky.origin
      assert_equal nil, @whisky.name
    end
  end

  context "allowing a single character" do
    setup do
      @dumb_phrase = "Central Time (US & Canada)"
      @clean_dumb  = "Central Time (US &amp; Canada)"
      @whisky = Whisky.new(:description => @dumb_phrase, :name => @dumb_phrase)
    end

    should "allow ampersands in the description" do
      assert_equal @dumb_phrase, @whisky.description
    end

    should "not allow ampersands in the name" do
      assert_equal @clean_dumb, @whisky.name
    end
  end

  context "allowing a regexp" do
    setup do
      @dumb_phrase = "<buttes> hey guy, I think <buttes> about <buttes>, because i have no clear opinion on <buttes>"
      @clean_phrase = "&lt;buttes&gt; hey guy, I think &lt;buttes&gt; about &lt;buttes&gt;, because i have no clear opinion on &lt;buttes&gt;"
      @whisky = Whisky.new(:measure => @dumb_phrase, :name => @dumb_phrase)
    end

    should "allow the regexp'd phrase in the measure" do
      assert_equal @dumb_phrase, @whisky.measure
    end

    should "not allow the regexp'd phrase in the name" do
      assert_equal @clean_phrase, @whisky.name
    end

    should "still clean non-matched parts" do
      @whisky.measure = "<script>alert('Cragganmore')</script>"
      assert_equal "&lt;script&gt;alert('Cragganmore')&lt;/script&gt;", @whisky.measure
    end
  end

  should "not die gruesomely without options specified" do
    animal = Animal.new(:name => "<script>alert('Grue')</script>")
    assert_equal "&lt;script&gt;alert('Grue')&lt;/script&gt;", animal.name
  end
end
