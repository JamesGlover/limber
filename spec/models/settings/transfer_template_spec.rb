# frozen_string_literal: true

require 'spec_helper'
require 'labware_creators/base'
require_relative 'shared_examples'

describe Settings::TransferTemplate do
  subject { Settings::TransferTemplate.new }

  let(:tested_name) { 'Transfer columns 1-12' }
  let(:tested_uuid) { 'transfer-columns-1-to-12' }
  let(:expected_list) { :transfer_templates }

  it_behaves_like 'a settings resource'
end
