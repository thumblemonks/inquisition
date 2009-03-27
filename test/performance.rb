require 'benchmark'
require File.join(File.dirname(__FILE__), 'test_helper')

@whisky = Whisky.new({})
Benchmark.bmbm do |x|
  x.report("normal") { 
    1_000.times { 
      @whisky.origin = "<script>foo</script>"
      @whisky.origin
      @whisky.instance_variable_set(:@origin, "<script>foo</script>")
      @whisky.origin
    } 
  }
  x.report("cleansed") { 
    1_000.times { 
      @whisky.name = "<script>foo</script>"
      @whisky.name
      @whisky.instance_variable_set(:@name, "<script>foo</script>")
      @whisky.name
    } 
  }
end
