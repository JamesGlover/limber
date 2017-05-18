# frozen_string_literal: true

shared_examples 'a settings resource' do
  describe '#populate' do
    has_a_working_api

    let(:uuid_cache) { UuidCache.new(filename: Rails.root.join('spec','data','uuid_cache.yml'), api: api) }

    it 'populates the templates list' do
      subject.populate(uuid_cache)
      expect(subject.uuid_for(tested_name)).to eq(tested_uuid)
    end

    it 'returns self to allow chaining' do
      expect(subject.populate(uuid_cache)).to eq(subject)
    end

    it 'can be deferred' do
      # When sequencescape is down
      expect(uuid_cache).to receive(:fetch).with(expected_list).and_raise(Errno::ECONNREFUSED)
      # We still pass through the exception
      expect { subject.populate(uuid_cache) }.to raise_error(Errno::ECONNREFUSED)
      # But late things recover
      expect(uuid_cache).to receive(:fetch).with(expected_list).and_return({ tested_name => tested_uuid})
      # And now we're able to grab our uuids
      expect(subject.uuid_for(tested_name)).to eq(tested_uuid)
    end
  end

  # We provide manual registration to assist with testing
  describe '#register' do
    it 'registers a template' do
      subject.register(name: tested_name, uuid: tested_uuid)
      expect(subject.uuid_for(tested_name)).to eq(tested_uuid)
    end
  end

  describe '#uuid_for' do
    context 'when the template exists' do
      before { subject.register(name: tested_name, uuid: tested_uuid) }
      it 'returns the uuid' do
        expect(subject.uuid_for(tested_name)).to eq(tested_uuid)
      end
    end

    context 'when the template is missing' do
      it 'returns nil' do
        expect(subject.uuid_for(tested_name)).to be nil
      end
    end
  end

  describe '#uuid_for!' do
    context 'when the template exists' do
      before { subject.register(name: tested_name, uuid: tested_uuid) }
      it 'returns the UUID' do
        expect(subject.uuid_for(tested_name)).to eq(tested_uuid)
      end
    end

    context 'when the template is missing' do
      it 'raises Settings::UnknownResource' do
        expect { subject.uuid_for!(tested_name) }.to raise_error(Settings::UnknownResource)
      end
    end
  end
end
