#This file is part of Illumina-B Pipeline is distributed under the terms of GNU General Public License version 3 or later;
#Please refer to the LICENSE and README files for information on licensing and authorship of this file.
#Copyright (C) 2015 Genome Research Ltd.
class Limber::FinalPoolPlate < Sequencescape::Plate
  # We need to specialise the transfers where this plate is a source so that it handles
  # the correct types
  class Transfer < ::Sequencescape::Transfer
    belongs_to :source, :class_name => 'FinalPoolPlate', :disposition => :inline
    attribute_reader :transfers

    def transfers_with_tube_mapping=(transfers)
      send(
        :transfers_without_tube_mapping=, Hash[
          transfers.map do |well, tube_json|
            [ well, ::Limber::StockLibraryTube.new(api, tube_json, false) ]
          end
        ]
      )
    end
    alias_method_chain(:transfers=, :tube_mapping)
  end

  has_many :transfers_to_tubes, :class_name => 'FinalPoolPlate::Transfer'

  def well_to_tube_transfers
    @transfers ||= transfers_to_tubes.first.transfers
  end

  # We know that if there are any transfers with this plate as a source then they are into
  # tubes.
  def has_transfers_to_tubes?
    not transfers_to_tubes.empty?
  end

  # Well locations ordered by columns.
  WELLS_IN_COLUMN_MAJOR_ORDER = (1..12).inject([]) { |a,c| a.concat(('A'..'H').map { |r| "#{r}#{c}" }) ; a }

  # Returns the tubes that an instance of this plate has been transferred into.
  # This ensures that tubes are sorted in column major order
  def tubes
    return [] unless has_transfers_to_tubes?
    WELLS_IN_COLUMN_MAJOR_ORDER.map(&well_to_tube_transfers.method(:[])).compact.uniq
  end

  def tubes_and_sources
    return [] unless has_transfers_to_tubes?
    WELLS_IN_COLUMN_MAJOR_ORDER.map do |l|
      [l, well_to_tube_transfers[l]]
    end.group_by do |_, t|
      t && t.uuid
    end.reject do |uuid, _|
      uuid.nil?
    end.map do |_, well_tube_pairs|
      [well_tube_pairs.first.last, well_tube_pairs.map(&:first)]
    end
  end
end
