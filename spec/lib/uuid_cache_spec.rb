# frozen_string_literal: true

require 'spec_helper'
require './lib/uuid_cache'

describe UuidCache do
  has_a_working_api

  subject(:uuid_cache) { UuidCache.new(filename: file.path, api: api) }

  context 'with a blank YAML file' do
    let(:file) { Tempfile.new }

    # api_stubs
    let!(:searches_request) { stub_api_get('searches', body: json(:searches_collection, available_searches: [:swipecard_search])) }
    let!(:transfer_templates_request) { stub_api_get('transfer_templates', body: json(:transfer_template_collection)) }
    let!(:plate_purposes) { stub_api_get('plate_purposes', body: json(:plate_purpose_collection)) }
    let!(:tube_purposes) { stub_api_get('tube', 'purposes', body: json(:searches_collection)) }

    describe '#build' do
      before { subject.build }
      %i[searches_request transfer_templates_request plate_purposes tube_purposes].each do |request|
        it("makes the #{request}") { expect(send(request)).to have_been_made.once }
      end
    end

    describe '#save' do
      before do
        subject.build
        subject.save
      end

      it 'writes the config to the YAML file' do
        file_content = YAML.load_file(file.path)
        expect(file_content[:searches]['Find user by swipecard code']).to eq('find-user-by-swipecard-code')
      end
    end

    describe '#fetch' do
      it 'lazy loads if necessary' do
        expect(subject.fetch(:searches)).to eq('Find user by swipecard code' => 'find-user-by-swipecard-code')
      end
    end
  end

  context 'with a populated YAML file' do
    let(:file) do
      tf = Tempfile.new
      tf.write({
        searches: { 'test1' => 'uuid' },
        purposes: { 'test2' => 'uuid' },
        transfer_templates: { 'test3' => 'uuid' }
      }.to_yaml)
      tf.rewind
      tf
    end

    it 'lets us fetch the cached version' do
      expect(subject.fetch(:purposes)).to eq('test2' => 'uuid')
    end
  end

  after do
    file.close
    file.unlink
  end
end
