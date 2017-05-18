
# frozen_string_literal: true

FactoryGirl.define do
  factory :search, class: Sequencescape::Search, traits: [:api_object] do
    json_root 'search'
    name 'Find something'
    named_actions %w[first last all]

    factory :swipecard_search do
      name 'Find user by swipecard code'
      uuid 'find-user-by-swipecard-code'
    end
  end

  # Builds all the transfer templates we're going to actually be using.
  factory :searches_collection, class: Sequencescape::Api::Associations::HasMany::AssociationProxy, traits: [:api_object] do
    size { available_searches.length }

    transient do
      json_root nil
      resource_actions %w[read first last]
      # While resources can be paginated, wells wont be.
      # Furthermore, we trust the api gem to handle that side of things.
      resource_url { "#{api_root}searches" }
      uuid nil
      available_searches [
        :swipecard_search
      ]
    end

    searches do
      available_searches.map { |template| associated(template) }
    end
  end
end
