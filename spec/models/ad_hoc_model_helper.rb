module AdHocModelHelper

  # attempt at late binding
  def self.included(parent)

    shared_examples_for :ad_hoc_model_example do
      it { expect(1).to eq 1 }
    end
  end
end
