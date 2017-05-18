# frozen_string_literal: true

require 'spec_helper'
require 'labware_creators/base'

describe Settings::TransferTemplate do
  subject { Settings::TransferTemplate.new }

  describe '#populate' do
    has_a_working_api

    let(:name) { 'test template' }
    let(:uuid) { SecureRandom.uuid }

    let(:uuid_cache) { UuidCache.new(filename: Rails.root.join('spec','data','uuid_cache.yml'), api: api) }

    let(:transfer_templates) { json(:transfer_template_collection) }

    it 'populates the templates list' do
      subject.populate(uuid_cache)
      expect(subject.uuid_for('Transfer columns 1-12')).to eq('transfer-columns-1-to-12')
    end

    it 'returns self to allow chaining' do
      expect(subject.populate(uuid_cache)).to eq(subject)
    end

    it 'can be deferred' do
      expect(uuid_cache).to receive(:fetch).with(:transfer_templates).and_raise(Errno::ECONNREFUSED)
      # We still pass through the exception
      expect { subject.populate(uuid_cache) }.to raise_error(Errno::ECONNREFUSED)
      # Things recover
      expect(uuid_cache).to receive(:fetch).with(:transfer_templates).and_return({ name => uuid})
      expect(subject.uuid_for(name)).to eq(uuid)
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
