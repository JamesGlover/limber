# frozen_string_literal: true

shared_context 'default transfer templates' do
  before do
    Limber::Application.config.transfer_templates = create :settings_transfer_template
  end
end

shared_context 'default searches' do
  before do
    Limber::Application.config.searches = create :settings_search
  end
end
