require "rails_helper"

RSpec.describe "Global Controller Spec" do

  it_behaves_like :vendor_example

  it_behaves_like :controller_example
  it_behaves_like :controller_param_example, "Controller"

  it { should have_match }

  shared_examples_for :shared_examples_for do
    it { expect(get_match).to eq "Controller" }
  end

  shared_context :shared_context do
    it_behaves_like :shared_examples_for
  end

  describe "new example block" do
    include_context :shared_context
  end

end
