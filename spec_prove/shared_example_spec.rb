require "byebug"
require "debug_helper"
include DebugHelper

debug_registry "Begin"

shared_examples :global do
  it { expect(true).to be_truthy }
end

debug_registry "After Global"

module Include
  shared_examples :include do
    it { expect(true).to be_truthy }
  end
end

debug_registry "After Module Include"

module SelfIncluded
  def self.included(m)
    shared_examples :self_included do
      it { expect(true).to be_truthy }
    end
  end
end

debug_registry "After Module SelfIncluded"

def registry
  RSpec.world.shared_example_group_registry.send(:shared_example_groups)
end

RSpec::Matchers.define :be_registered_globally do
  match do |key|
    expect(registry[:main][key]).to be_instance_of(RSpec::Core::SharedExampleGroupModule)
  end
end

RSpec.describe "Global Example" do
  it("is declared globally") { expect(:global).to be_registered_globally }
end

RSpec.describe "Include Example" do
  it("is declared globally") { expect(:include).to be_registered_globally }
end

RSpec.describe "Declare Self Included Example" do
  it("is NOT declared at load time") { expect(:self_included).to be_registered_globally }
end

RSpec.describe "Include Self Included Example" do
  include SelfIncluded
  it("is declared globally at include time") { expect(:self_included).to be_registered_globally }
end

RSpec.describe "In Scope Example" do
  shared_examples :in_scope do
    it { expect(true).to be_truthy }
  end

  it "is declared within scope" do
    expect(registry[RSpec::ExampleGroups::InScopeExample][:in_scope]).to be_instance_of(RSpec::Core::SharedExampleGroupModule)
  end
end

shared_context :inline do
  module SelfIncludedInline
    def self.included(m)
      shared_examples_for :self_included_inline do
        it { expect(true).to be_truthy }
      end
    end
  end
end

RSpec.describe "Declare Self Included Inline Example" do
  include_context :inline
  it("is declared globally at load time") { expect(:self_included_inline).to be_registered_globally }
end

RSpec.describe "Include Self Included Inline Example" do
  include_context :inline
  include SelfIncludedInline
  it("is declared globally at include time") { expect(:self_included_inline).to be_registered_globally }
end

RSpec.describe "Include File Included Inline Example" do
  require_relative "shared_example_file_include"
  it("is declared globally at include time") { expect(:file_include).to be_registered_globally }
end

RSpec.describe "Include File Included Inline Example Nested" do
  describe "Nested" do
    require_relative "shared_example_file_include"
    it("is declared globally at include time") { expect(:file_include).to be_registered_globally }
  end
end

debug_registry "End"
