require "byebug"
require "debug_helper"
include DebugHelper

# private method on main that gets inherited by RSpec.describe
def global_foo
  "global"
end

raise "global_foo not defined" unless global_foo

RSpec.describe "Global Foo" do

  raise "global_foo not defined" unless global_foo

  begin
    raise "global_foo not defined" unless global_foo
  end

  it "is a private method" do
    expect(self).not_to respond_to :global_foo
    expect(global_foo).to eq "global"
  end

  it "is added to Object" do
    expect(Object.new.send(:global_foo)).to eq "global"
  end
end
