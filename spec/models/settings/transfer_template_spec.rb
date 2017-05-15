# frozen_string_literal: true

require 'spec_helper'
require 'labware_creators/base'

describe Settings::TransferTemplate do
  subject { Settings::TransferTemplate.new }

  describe '#populate' do
    has_a_working_api

    let(:transfer_templates) { json(:transfer_template_collection) }

    let!(:transfer_tamples_index_request) do
      stub_api_get('transfer_templates', body: transfer_templates)
    end

    it 'requests templates from the api' do
      subject.populate(api)
      expect(transfer_tamples_index_request).to have_been_made.once
    end

    it 'populates the templates list' do
      subject.populate(api)
      expect(subject.uuid_for('Test transfers')).to eq('transfer-template-uuid')
    end
  end

  # We provide manual registration to assist with testing
  describe '#register' do
    let(:name) { 'test template' }
    let(:uuid) { SecureRandom.uuid }

    it 'registers a template' do
      subject.register(name: name, uuid: uuid)
      expect(subject.uuid_for(name)).to eq(uuid)
    end
  end

  describe '#uuid_for' do
    let(:name) { 'test template' }
    let(:uuid) { SecureRandom.uuid }

    context 'when the template exists' do
      before { subject.register(name: name, uuid: uuid) }
      it 'returns the uuid' do
        expect(subject.uuid_for(name)).to eq(uuid)
      end
    end
    context 'when the template is missing' do
      it 'returns nil' do
        expect(subject.uuid_for(name)).to be nil
      end
    end
  end

  describe '#uuid_for!' do
    let(:name) { 'test template' }
    let(:uuid) { SecureRandom.uuid }

    context 'when the template exists' do
      before { subject.register(name: name, uuid: uuid) }
      it 'returns the UUID' do
        expect(subject.uuid_for(name)).to eq(uuid)
      end
    end
    context 'when the template is missing' do
      it 'raises Settings::TransferTemplate::UnknownTemplate' do
        expect { subject.uuid_for!(name) }.to raise_error(Settings::TransferTemplate::UnknownTemplate)
      end
    end
  end
end
