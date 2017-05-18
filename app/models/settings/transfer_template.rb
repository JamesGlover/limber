# frozen_string_literal: true

#
# Class Settings::TransferTemplate provides a means of easily
# looking up transfer templates by name.
#
class Settings::TransferTemplate
  UnknownTemplate = Class.new(StandardError)

  def initialize
    @store = {}
  end

  #
  # Returns the uuid for a transfer template with a given name
  # Returns nil if no template is found
  #
  # @param [String] name The name of the transfer template
  #
  # @return [String,nil] The uuid matching that transfer template.
  #
  def uuid_for(name)
    check_cache
    @store[name]
  end

  #
  # Manually register a transfer template and its uuid.
  # This is mainly provided to assist with testing.
  #
  # @param [String] name: <description>
  # @param [String] uuid: <description>
  #
  # @return [<type>] <description>
  #
  def register(name:, uuid:)
    raise StandardError, 'Must specify a name' if name.nil?
    raise StandardError, 'Must specify a uuid' if uuid.nil?
    @store[name] = uuid
  end

  #
  # Builds a hash of template names and the corresponding uuids
  #
  # @param [Sequencescape::Api instance] api The Sequencescape::Api instance to retried transfer templates from
  #
  # @return [Settings::TransferTemplate] returns itself
  #
  def populate(uuid_cache)
    Rails.logger.info('Loading transfer templates...')
    begin
      @store.merge!(uuid_cache.fetch(:transfer_templates))
    rescue => original_exception
      @unprocesed_cache = uuid_cache
      raise original_exception
    end
    self
  end

  #
  # Returns the uuid for a transfer template with a given name
  # Raises Settings::TransferTemplate::UnknownTemplate if no template is found
  #
  # @param [String] name The name of the transfer template
  #
  # @return [String] The uuid matching that transfer template.
  #
  def uuid_for!(name)
    uuid_for(name) || raise(UnknownTemplate, "Unknown template: #{name}. Know templates: #{known_templates}")
  end

  def known_templates
    @store.keys
  end

  private

  def check_cache
    populate(@unprocesed_cache) if @unprocesed_cache
  end
end
