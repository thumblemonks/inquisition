$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'test/unit'
require 'activerecord'
require 'activesupport'
require 'shoulda'
require 'inquisition'
require 'models'
