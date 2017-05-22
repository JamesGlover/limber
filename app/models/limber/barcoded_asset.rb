# frozen_string_literal: true

# This file is part of SEQUENCESCAPE is distributed under the terms of GNU General Public License version 1 or later;

# This class allows us to retrieve all assets in a single barcode lookup
class Limber::BarcodedAsset < Sequencescape::BarcodedAsset
  # We might actually be able to do something better here.
  def parent
    @parent ||= parent_search.first(barcode: barcode.ean13)
  end

  attribute_accessor :state
  belongs_to :plate_purpose

  alias purpose= plate_purpose=
  alias purpose plate_purpose

  delegate :uuid, to: :purpose, prefix: true
  delegate :name, to: :purpose, prefix: true

  private

  def parent_search
    api.search.find(Limber::Application.config.searches.uuid_for!('Find source assets by destination asset barcode'))
  end
end
