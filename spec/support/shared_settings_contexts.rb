# frozen_string_literal: true

shared_context 'default transfer templates' do
  before do
    Limber::Application.config.transfer_templates = create :settings_transfer_template
  end
end
