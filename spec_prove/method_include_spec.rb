require "byebug"
require "debug_helper"
include DebugHelper

module Include
  def include_foo
    "include"
  end
end

shared_context :shared_context_foo do
  def shared_foo
    "shared"
  end
end

RSpec.describe "Example Foo" do
  def example_foo
    "example"
  end
  subject { self }
  it { should respond_to :example_foo }
  it { should_not respond_to :include_foo }
  it { should_not respond_to :shared_foo }
  describe "nested" do
    it { should respond_to :example_foo }
  end
end

RSpec.describe "Manually Included Foo" do
  include Include
  subject { self }
  it { should_not respond_to :example_foo }
  it { should respond_to :include_foo }
  it { should_not respond_to :shared_foo }
end

RSpec.describe "Following Manually Included Foo" do
  subject { self }
  it("proves manual incude is local") { should_not respond_to :include_foo }
end

RSpec.describe "Config Included Foo" do
  before(:all) { RSpec.configure { |c| c.include Include }}
  subject { self }
  it { should respond_to :include_foo }
end

RSpec.describe "Following Config Included Foo" do
  subject { self }
  it("proves RSpec.configure#include is global") { should respond_to :include_foo }
end

RSpec.describe "Sharing Context Foo" do
  subject { self }
  include_context :shared_context_foo
  it { should respond_to :shared_foo }
end

RSpec.describe "Following Config Included Foo" do
  subject { self }
  it("proves shared context is not global") { should_not respond_to :shared_foo }
end

