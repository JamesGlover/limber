# frozen_string_literal: true

require_relative '../purpose_config'
namespace :config do
  desc 'Generates a configuration file for the current Rails environment'

  require Rails.root.join('config', 'robots')

  task generate: :environment do
    api = Sequencescape::Api.new(Limber::Application.config.api_connection_options)

    # Build the uuid cache
    uuid_cache = UuidCache.new(filename: Rails.root.join('config', 'settings', "#{Rails.env}_uuid_cache.yml"), api: api)
    uuid_cache.build
    uuid_cache.save

    all_purposes = api.plate_purpose.all.index_by(&:name).merge(api.tube_purpose.all.index_by(&:name))

    purpose_config = YAML.parse_file('config/purposes.yml').to_ruby.map do |name, options|
      PurposeConfig.load(name, options, all_purposes, api)
    end

    tracked_purposes = purpose_config.map do |config|
      all_purposes[config.name] ||= config.register!
    end

    # Build the configuration file based on the server we are connected to.
    CONFIG = {}.tap do |configuration|
      configuration[:large_insert_limit] = 250

      configuration[:searches] = {}.tap do |searches|
        puts 'Preparing searches ...'
        api.search.all.each do |search|
          searches[search.name] = search.uuid
        end
      end

      configuration[:printers] = {}.tap do |printers|
        printers[:plate_a] = 'g316bc'
        printers[:plate_b] = 'g311bc2'
        printers[:tube]    = 'g311bc1'
        printers['limit'] = 5
        printers['default_count'] = 2
      end

      configuration[:purposes] = {}.tap do |labware_purposes|
        puts 'Preparing purpose configs...'
        purpose_config.each do |purpose|
          labware_purposes[purpose.uuid] = purpose.config
        end
      end

      configuration[:purpose_uuids] = tracked_purposes.each_with_object({}) do |purpose, store|
        store[purpose.name] = purpose.uuid
      end

      configuration[:robots]      = ROBOT_CONFIG
      configuration[:qc_purposes] = []

      configuration[:request_types] = {}.tap do |request_types|
        request_types['illumina_htp_library_creation']    = ['Lib Norm', false]
        request_types['illumina_a_isc']                   = ['ISCH lib pool', false]
        request_types['illumina_a_re_isc']                = ['ISCH lib pool', false]
      end
    end

    # Write out the current environment configuration file
    File.open(Rails.root.join('config', 'settings', "#{Rails.env}.yml"), 'w') do |file|
      file.puts(CONFIG.to_yaml)
    end
  end

  task default: :generate
end
