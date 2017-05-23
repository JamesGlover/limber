# frozen_string_literal: true

require 'spec_helper'
require 'labware_creators/base'
require_relative 'shared_examples'

describe Settings::Purpose do
  subject(:settings) { Settings::Purpose.new(purpose_config: purpose_config) }

  let(:purpose_config) { Rails.root.join('spec','data','purposes.yml') }

  let(:tested_name) { 'Child Purpose 0' }
  let(:tested_uuid) { 'child-purpose-0' }
  let(:expected_list) { :purposes }

  it_behaves_like 'a settings resource'

  shared_examples 'a purpose_config' do
    it 'returns a presenter class' do
      expect(subject.presenter_class).to eq (presenter_class)
    end
    it 'returns a creator class' do
      expect(subject.creator_class).to eq (creator_class)
    end
    it 'returns a state_changer class' do
      expect(subject.state_changer_class).to eq (state_changer_class)
    end
    it 'returns an asset_type' do
      expect(subject.asset_type).to eq (asset_type)
    end
    it 'returns a transfer_template' do
      expect(subject.transfer_template).to eq (transfer_template)
    end
  end

  describe '#config_for' do
    subject { settings.config_for(test_purpose_uuid) }
    let(:test_purpose_uuid) { 'test-purpose-uuid' }
    let(:state_changer_class) { StateChangers::DefaultStateChanger }

    before do
      settings.register(name: test_purpose_name, uuid: test_purpose_uuid)
    end

    context 'custom_settings' do
      let(:test_purpose_name) { 'Custom Purpose' }
      it_behaves_like 'a purpose_config'

      let(:presenter_class) { Presenters::PcrPresenter }
      let(:creator_class) { LabwareCreators::TaggedPlate }
      let(:asset_type) { 'plate' }
      let(:transfer_template) { 'Example transfer' }
    end

    context 'default_settings' do
      let(:test_purpose_name) { 'Default Purpose' }
      it_behaves_like 'a purpose_config'
      let(:presenter_class) { Presenters::StandardPresenter }
      let(:creator_class) { LabwareCreators::Base }
      let(:asset_type) { 'plate' }
      let(:transfer_template) { nil }
    end
  end

end
