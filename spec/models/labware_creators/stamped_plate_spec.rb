# frozen_string_literal: true

require 'spec_helper'
require 'labware_creators/base'
require_relative '../../support/shared_tagging_examples'
require_relative 'shared_examples'

# Uses a custom transfer template to transfer material into the new plate
RSpec.describe LabwareCreators::StampedPlate do
  it_behaves_like 'it only allows creation from plates'
  it_behaves_like 'it has no custom page'

  has_a_working_api

  let(:parent_uuid) { 'example-plate-uuid' }
  let(:plate_barcode) { SBCF::SangerBarcode.new(prefix: 'DN', number: 2).machine_barcode.to_s }
  let(:plate_size) { 96 }
  let(:plate) { create :v2_stock_plate, uuid: parent_uuid, barcode_number: '2', size: plate_size, outer_requests: requests }
  let(:child_plate) { create :v2_plate, uuid: 'child-uuid', barcode_number: '3', size: plate_size, outer_requests: requests }
  let(:transfer_template_uuid) { 'custom-pooling' }
  let(:transfer_template) { json :transfer_template, uuid: transfer_template_uuid }
  let(:requests) { Array.new(plate_size) { |i| create :library_request, state: 'started', uuid: "request-#{i}" } }

  let(:child_purpose_uuid) { 'child-purpose' }
  let(:child_purpose_name) { 'Child Purpose' }

  let(:user_uuid) { 'user-uuid' }

  before do
    create(:purpose_config, name: child_purpose_name, uuid: child_purpose_uuid)
    stub_v2_plate(child_plate, stub_search: false)
    stub_v2_plate(plate, stub_search: false)
  end

  let(:form_attributes) do
    {
      purpose_uuid: child_purpose_uuid,
      parent_uuid:  parent_uuid,
      user_uuid: user_uuid
    }
  end

  subject do
    LabwareCreators::StampedPlate.new(api, form_attributes)
  end

  context 'on new' do
    it 'can be created' do
      expect(subject).to be_a LabwareCreators::StampedPlate
    end
  end

  shared_examples 'a stamped plate creator' do
    describe '#save!' do
      let!(:plate_creation_request) do
        stub_api_post('plate_creations',
                      payload: { plate_creation: {
                        parent: parent_uuid,
                        child_purpose: child_purpose_uuid,
                        user: user_uuid
                      } },
                      body: json(:plate_creation))
      end

      let!(:plate_request) do
        stub_v2_plate(plate, stub_search: false)
      end

      let!(:child_plare_request) do
        stub_v2_plate(child_plate, stub_search: false)
      end

      let!(:transfer_template_request) do
        stub_api_get(transfer_template_uuid, body: transfer_template)
      end

      let!(:transfer_creation_request) do
        stub_api_post('transfer_request_collections',
                      payload: { transfer_request_collection: {
                        user: user_uuid,
                        transfer_requests: transfer_requests
                      } },
                      body: '{}')
      end

      it 'makes the expected requests' do
        expect(subject.save!).to eq true
        expect(plate_creation_request).to have_been_made
        expect(transfer_creation_request).to have_been_made
      end
    end
  end

  context '96 well plate' do
    let(:plate_size) { 96 }

    let(:transfer_requests) do
      WellHelpers.column_order(plate_size).each_with_index.map do |well_name, index|
        {
          'source_asset' => "2-well-#{well_name}",
          'target_asset' => "3-well-#{well_name}",
          'outer_request' => "request-#{index}"
        }
      end
    end

    it_behaves_like 'a stamped plate creator'
  end

  context '384 well plate' do
    let(:plate_size) { 384 }

    let(:transfer_requests) do
      WellHelpers.column_order(plate_size).each_with_index.map do |well_name, index|
        {
          'source_asset' => "2-well-#{well_name}",
          'target_asset' => "3-well-#{well_name}",
          'outer_request' => "request-#{index}"
        }
      end
    end

    it_behaves_like 'a stamped plate creator'
  end

  context 'more complicated scenarios' do
    let(:plate) { create :v2_plate, uuid: parent_uuid, barcode_number: '2', wells: wells }

    context 'with multiple requests of different types' do
      let(:request_type_a) { create :request_type, key: 'rt_a' }
      let(:request_type_b) { create :request_type, key: 'rt_b' }
      let(:request_a) { create :library_request, request_type: request_type_a, uuid: 'request-a' }
      let(:request_b) { create :library_request, request_type: request_type_b, uuid: 'request-b' }
      let(:request_c) { create :library_request, request_type: request_type_a, uuid: 'request-c' }
      let(:request_d) { create :library_request, request_type: request_type_b, uuid: 'request-d' }
      let(:wells) do
        [
          create(:v2_stock_well, uuid: '2-well-A1', location: 'A1', aliquot_count: 1, requests_as_source: [request_a, request_b]),
          create(:v2_stock_well, uuid: '2-well-B1', location: 'B1', aliquot_count: 1, requests_as_source: [request_c, request_d]),
          create(:v2_stock_well, uuid: '2-well-c1', location: 'C1', aliquot_count: 0, requests_as_source: [])
        ]
      end

      context 'when a request_type is supplied' do
        let(:form_attributes) do
          {
            purpose_uuid: child_purpose_uuid,
            parent_uuid:  parent_uuid,
            user_uuid: user_uuid,
            filters: { request_type_keys: [request_type_b.key] }
          }
        end

        let(:transfer_requests) do
          [
            {
              'source_asset' => '2-well-A1',
              'target_asset' => '3-well-A1',
              'outer_request' => 'request-b'
            },
            {
              'source_asset' => '2-well-B1',
              'target_asset' => '3-well-B1',
              'outer_request' => 'request-d'
            }
          ]
        end

        it_behaves_like 'a stamped plate creator'
      end

      context 'when a request_type is not supplied' do
        let(:form_attributes) do
          {
            purpose_uuid: child_purpose_uuid,
            parent_uuid:  parent_uuid,
            user_uuid: user_uuid
          }
        end

        let(:transfer_requests) do
          [
            {
              'source_asset' => '2-well-A1',
              'target_asset' => '3-well-A1',
              'outer_request' => 'request-b'
            },
            {
              'source_asset' => '2-well-B1',
              'target_asset' => '3-well-B1',
              'outer_request' => 'request-d'
            }
          ]
        end

        it 'raises an exception' do
          expect { subject.save! }.to raise_error(LabwareCreators::ResourceInvalid)
        end
      end
    end

    context 'such as the ISC pipeline post pooling' do
      # Here we have multiple aliquots in the source well, which all need to be transferred
      # We don't specify an outer request, and Sequencescape should just move the aliquots across
      # as normal.
      let(:request_type) { create :request_type, key: 'rt_a' }
      let(:request_a) { create :library_request, request_type: request_type, uuid: 'request-a' }
      let(:request_b) { create :library_request, request_type: request_type, uuid: 'request-b' }
      let(:request_c) { create :library_request, request_type: request_type, uuid: 'request-c' }
      let(:request_d) { create :library_request, request_type: request_type, uuid: 'request-d' }
      let(:aliquots_a) do
        [
          create(:v2_aliquot, library_state: 'started', outer_request: request_a),
          create(:v2_aliquot, library_state: 'started', outer_request: request_b)
        ]
      end
      let(:aliquots_b) do
        [
          create(:v2_aliquot, library_state: 'started', outer_request: request_c),
          create(:v2_aliquot, library_state: 'started', outer_request: request_d)
        ]
      end

      let(:wells) do
        [
          create(:v2_well, uuid: '2-well-A1', location: 'A1', aliquots: aliquots_a),
          create(:v2_well, uuid: '2-well-B1', location: 'B1', aliquots: aliquots_b)
        ]
      end

      context 'when a request_type is supplied' do
        let(:form_attributes) do
          {
            purpose_uuid: child_purpose_uuid,
            parent_uuid:  parent_uuid,
            user_uuid: user_uuid
          }
        end

        let(:transfer_requests) do
          [
            {
              'source_asset' => '2-well-A1',
              'target_asset' => '3-well-A1'
            },
            {
              'source_asset' => '2-well-B1',
              'target_asset' => '3-well-B1'
            }
          ]
        end

        it_behaves_like 'a stamped plate creator'
      end
    end
  end
end
