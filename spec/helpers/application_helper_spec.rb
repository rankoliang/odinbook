require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe '.bootstrap_flash' do
    subject(:bootstrap_class) { helper.bootstrap_flash(flash_type) }

    context 'when the flash type is notice' do
      let(:flash_type) { 'notice' }

      it 'returns alert-success' do
        expect(bootstrap_class).to eq 'alert-success'
      end
    end

    context 'when the flash type is alert' do
      let(:flash_type) { 'alert' }

      it 'returns alert-success' do
        expect(bootstrap_class).to eq 'alert-danger'
      end
    end

    context 'when the flash type is unknown' do
      let(:flash_type) { '' }

      it 'returns alert-success' do
        expect(bootstrap_class).to eq 'alert-info'
      end
    end
  end
end
