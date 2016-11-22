require "rails_helper"

RSpec.describe "Worker Spec" do

  it { should have_match }

  it { expect(get_match).to eq "Worker" }

  shared_examples_for :shared_examples_for do
    it { expect(get_match).to eq "Worker" }
  end

  shared_context :shared_context do
    it_behaves_like :shared_examples_for
  end

  describe "new example block" do
    include_context :shared_context
  end

end
