# frozen_string_literal: true

#
# Class UuidCache provides a persistent cache of uuids for
# various Sequencescape models
#
class UuidCache
  attr_reader :api, :store, :filename
  #
  # Array of models to query, and the list they'll get stored in
  MODELS = [
    %i[search searches],
    %i[transfer_template transfer_templates],
    %i[plate_purpose purposes],
    %i[tube_purpose purposes]
  ].freeze

  def initialize(filename:, api:)
    @api = api
    @store = Hash.new { |store, list| store[list] = {} }
    @filename = filename
    @unbuilt = true
    populate_from_cache
  end

  def build
    MODELS.each do |model, list_name|
      list = store[list_name]
      api.public_send(model).all.each do |record|
        list[record.name] = record.uuid
      end
    end
    @unbuilt = false
  end

  def save
    File.open(filename, 'w') do |file|
      file << @store.to_yaml
    end
  end

  def fetch(list)
    build if @unbuilt
    @store.fetch(list)
  end

  private

  def populate_from_cache
    begin
      @store = YAML.load_file(filename) || @store
      @unbuilt = false
    rescue Errno::ENOENT
      Rails.logger.info('No uuid log file found.')
    end
  end
end
