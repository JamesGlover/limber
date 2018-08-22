# frozen_string_literal: true

module PlateHelper
  class WellFailingPresenter < BasicObject
    def initialize(form, presenter)
      @form = form
      @presenter = presenter
    end

    def respond_to?(name, include_private = false)
      super || @presenter.respond_to?(name, include_private)
    end

    def method_missing(name, *args, &block)
      @presenter.send(name, *args, &block)
    end
    protected :method_missing

    def aliquot_partial
      'well_failing_aliquot'
    end

    attr_reader :form
  end

  def fail_wells_presenter_from(form, presenter)
    WellFailingPresenter.new(form, presenter)
  end

  def insert_size_class(pool)
    (pool.dig('insert_size', 'from') || 0) > Settings.large_insert_limit ? 'large-insert-size' : ''
  end

  # Altered to sort by column first then row
  def sortable_well_location_for(location)
    match = location.match(/^([A-Z])(\d+)$/)
    [match[2].to_i, match[1]]
  end
  private :sortable_well_location_for

  def sorted_pre_cap_group_json
    current_plate.wells.each_with_object({}) do |well, pool_store|
      well.active_requests.each do |request|
        wa = []
        pool_store[request.pre_capture_pool.id] ||= { 'wells' => wa, 'all_wells' => wa, 'failures' => [] }
        pool_store[request.pre_capture_pool.id]['wells'] << well.location
      end
    end.to_json.html_safe
  end

  def pools_by_id(pools)
    pools_by_position = pools.each_with_object({}) do |(key, value), result|
      result[key] = WellHelpers.sort_in_column_order(value['wells']).first
    end.sort_by { |_k, v| WellHelpers.well_coordinate(v) }.map.with_index { |v, i| [v.first, i + 1] }.to_h

    {}.tap do |h|
      pools.each do |key, value|
        value['wells'].each do |well|
          h[well] = pools_by_position[key]
        end
      end
    end
  end

  def current_plate
    (@labware_creator || @presenter).labware
  end
end
