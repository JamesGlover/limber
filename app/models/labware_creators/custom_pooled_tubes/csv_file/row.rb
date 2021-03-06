# frozen_string_literal: true

module LabwareCreators # rubocop:todo Style/Documentation
  require_dependency 'labware_creators/custom_pooled_tubes/csv_file'
  #
  # Class CsvRow provides a simple wrapper for handling and validating
  # individual CSV rows
  #
  class CustomPooledTubes::CsvFile::Row
    include ActiveModel::Validations

    MISSING_SOURCE = 'is blank in %s but a destination has been specified. '\
                     'Either supply a source, or remove the destination.'
    MISSING_VOLUME = 'is blank in %s but a destination has been specified. '\
                     'Either supply a positive volume, or remove the destination.'
    NEGATIVE_VOLUME = 'is %%{value} in %s but a destination has been specified. '\
                      'Either supply a positive volume, or remove the destination.'

    attr_reader :header, :source, :destination, :volume, :index

    validates :source,
              presence: {
                message: ->(object, _data) { MISSING_SOURCE % object }
              },
              unless: :empty?

    validates :volume,
              presence: {
                message: ->(object, _data) { MISSING_VOLUME % object }
              },
              numericality: {
                greater_than: 0,
                message: ->(object, _data) { NEGATIVE_VOLUME % object }
              },
              unless: :empty?

    validates :source, inclusion: { in: WellHelpers.column_order, message: "contains an invalid well name: '%{value}'" } # rubocop:todo Style/FormatStringToken

    delegate :source_column, :destination_column, :volume_column, to: :header

    def initialize(header, index, row_data)
      @header = header
      @index = index
      @source = (row_data[source_column] || '').strip.upcase
      @destination = (row_data[destination_column] || '').strip.downcase
      # We use %.to_i to avoid converting nil to 0. This allows us to write less
      # confusing validation error messages.
      @volume = row_data[volume_column]&.to_i
    end

    def to_s
      if source.present?
        "row #{index} [#{source}]"
      else
        "row #{index}"
      end
    end

    def empty?
      destination.blank?
    end
  end
end
