require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'inquisition'

#Test models, yeah.
require 'lib/animal'
require 'lib/whisky'

class Test::Unit::TestCase
end
