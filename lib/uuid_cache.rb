#
# Class UuidCache provides a persistent cache of uuids for
# various Sequencescape models
#
class UuidCache
  attr_reader :api, :store
  #
  # Array of models to query, and the list they'll get stored in
  MODELS = [
    [:search, :searches],
    [:transfer_template, :transfer_templates],
    [:plate_purpose, :purposes],
    [:tube_purpose, :purposes]
  ]

  def initialize(file:,api:)
    @api = api
    @store = Hash.new { |store, list| store[list] = {} }
  end

  def build
    MODELS.each do |model, list_name|
      list = store[list_name]
      api.public_send(model).all.each do |record|
        list[record.name] = record.uuid
      end
    end
  end

end
