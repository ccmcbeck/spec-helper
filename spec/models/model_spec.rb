require "rails_helper"
require_relative "ad_hoc_model_helper"

RSpec.describe "Model Spec" do
  include AdHocModelHelper

  # ad hoc
  it_behaves_like :ad_hoc_model_example

  # model helper
  it { expect(get_match).to eq "Model" }

  it_behaves_like :model_example

  it { should have_match }

  # global helper
  it_behaves_like :vendor_example

end
