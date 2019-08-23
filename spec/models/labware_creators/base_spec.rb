# frozen_string_literal: true

require 'spec_helper'
require 'labware_creators/base'
require_relative 'shared_examples'

# CreationForm is the base class for our forms
RSpec.describe LabwareCreators::Base do
  it_behaves_like 'it does not allow creation'

  let(:basic_purpose)  { 'test-purpose' }
  let(:tagged_purpose) { 'dummy-purpose' }

  before do
    create :purpose_config, uuid: basic_purpose, creator_class: 'LabwareCreators::Base'
    create :purpose_config, uuid: tagged_purpose, creator_class: 'LabwareCreators::TaggedPlate'
  end

  context 'with a custom transfer-template' do
    before do
      create :purpose_config, transfer_template: 'Custom transfer template', uuid: 'test-purpose'
      Settings.transfer_templates['Custom transfer template'] = 'custom-template-uuid'
    end

    subject { LabwareCreators::Base.new(nil, purpose_uuid: 'test-purpose') }

    it 'can lookup form for another purpose' do
      expect(subject.transfer_template_uuid).to eq('custom-template-uuid')
    end
  end
end
