require "rails_helper"

RSpec.describe "Developers Controller Spec" do

  it_behaves_like :controller_example
  it_behaves_like :controller_param_example, "Developers"

  it_behaves_like :developers_controller_example

  it { should have_match }

  shared_examples_for :shared_examples_for do
    it { expect(get_match).to eq "Developers" }
  end

  shared_context :shared_context do
    it_behaves_like :shared_examples_for
  end

  describe "new example block" do
    include_context :shared_context
  end

  describe "override in block works" do
    shared_examples_for :vendor_example do
      it { expect(true).to be_truthy }
    end
    it_behaves_like :vendor_example
  end

  describe "override again in block works" do
    shared_examples_for :vendor_example do
      it { expect(true).to be_truthy }
    end
    it_behaves_like :vendor_example
  end

  describe "override again in proc works" do
    Proc.new do
      shared_examples_for :vendor_example do
        it { expect(true).to be_truthy }
      end
    end.call
    it_behaves_like :vendor_example
  end
end
