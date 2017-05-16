
# frozen_string_literal: true

FactoryGirl.define do
  factory :settings_transfer_template, class: Settings::TransferTemplate do
    transient do
      templates [{
        name: 'Transfer columns 1-12',
        uuid: 'transfer-columns-1-to-12'
      }, {
        name: 'Transfer wells to specific tubes defined by submission',
        uuid: 'transfer-to-wells-by-submission-uuid'
      }, {
        name: 'Transfer wells to MX library tubes by submission',
        uuid: 'transfer-to-mx-tubes-on-submission'
      },
                 {
                   name: 'Transfer from tube to tube by submission',
                   uuid: 'transfer-from-tube-to-tube-by-submission'
                 }]
    end

    after(:build) do |stt, evaluator|
      evaluator.templates.each { |template| stt.register(template) }
    end

    skip_create
  end
end
