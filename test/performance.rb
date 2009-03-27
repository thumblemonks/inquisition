require 'benchmark'
require File.join(File.dirname(__FILE__), 'test_helper')

@whisky = Whisky.new({})
Benchmark.bmbm do |x|
  x.report("normal") do 
    1_000.times do 
      @whisky.origin = "<script>foo</script>"
      @whisky.instance_variable_set(:@origin, "<script>foo</script>")
      @whisky.origin
    end 
  end
  x.report("cleansed") do 
    1_000.times do 
      @whisky.name = "<script>foo</script>"
      @whisky.instance_variable_set(:@name, "<script>foo</script>")
      @whisky.name
    end 
  end
  x.report("writer only") do 
    1_000.times do @whisky.name = "<script>foo</script>" end 
  end
  x.report("reader only") do 
    1_000.times do 
      @whisky.instance_variable_set(:@name, "<script>foo</script>")
      @whisky.name = "<script>foo</script>" 
    end 
  end
end
