require "byebug"
require "debug_helper"
include DebugHelper

puts "Global is #{self} #{self.class}"

RSpec.describe "Top" do
  puts "Top is #{self} #{self.class}"

  describe "Describe" do
    puts "Top is #{self} #{self.class} derived from #{self.ancestors}"
  end

  describe "Context" do
    puts "Top is #{self} #{self.class} derived from #{self.ancestors}"
  end
end
