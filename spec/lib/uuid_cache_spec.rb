# frozen_string_literal: true

require 'spec_helper'
require './lib/uuid_cache'

describe UuidCache do
  has_a_working_api

  subject(:uuid_cache) { UuidCache.new(file: file, api: api) }

  context 'with a blank yaml file' do
    let(:file) { Tempfile.new }

    # api_stubs
    let!(:searches_request) { stub_api_get('searches', body: json(:searches_collection)) }
    let!(:transfer_templates_request) { stub_api_get('transfer_templates', body: json(:transfer_template_collection)) }
    let!(:plate_purposes) { stub_api_get('plate_purposes', body: json(:plate_purpose_collection)) }
    let!(:tube_purposes) { stub_api_get('tube', 'purposes', body: json(:searches_collection)) }

    describe '#build' do
      before { uuid_cache.build }
      [:searches_request, :transfer_templates_request, :plate_purposes, :tube_purposes].each do |request|
        it("makes the #{request}") { expect(send(request)).to have_been_made.once }
      end
    end
  end
end
