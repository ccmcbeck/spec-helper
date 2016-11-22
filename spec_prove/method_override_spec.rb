require "byebug"
require "debug_helper"
include DebugHelper

def foo
  "global"
end

module Include
  def foo
    "include"
  end
end

shared_context :shared_context_foo do
  def foo
    "shared"
  end
end

RSpec.describe "Global Foo" do
  subject { self.send :foo }
  it { should eq "global" }
end

RSpec.describe "Example Foo" do
  def foo
    "example"
  end
  subject { self.send :foo }
  it { should eq "example" }
end

RSpec.describe "Manually Included Foo" do
  include Include
  subject { self.send :foo }
  it { should eq "include" }
end

RSpec.describe "Following Manually Included Foo" do
  subject { self.send :foo }
  it("does not override") { should eq "global" }
end

RSpec.describe "Config Included Foo" do
  before(:all) { RSpec.configure { |c| c.include Include }}
  subject { self.send :foo }
  it { should eq "include" }
end

RSpec.describe "Following Config Included Foo" do
  subject { self.send :foo }
  it("proves RSpec.configure#include is global") { should eq "include" }
end

RSpec.describe "Sharing Context Foo" do
  subject { self.send :foo }
  include_context :shared_context_foo
  it { should eq "shared" }
end

RSpec.describe "Following Config Included Foo" do
  subject { self.send :foo }
  it("proves shared context is not global") { should eq "include" }
end

