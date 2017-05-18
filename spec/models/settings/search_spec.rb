# frozen_string_literal: true

require 'spec_helper'
require 'labware_creators/base'
require_relative 'shared_examples'

describe Settings::Search do
  subject { Settings::Search.new }

  let(:tested_name) { 'Find user by swipecard code' }
  let(:tested_uuid) { 'find-user-by-swipecard-code' }
  let(:expected_list) { :searches }

  it_behaves_like 'a settings resource'
end
