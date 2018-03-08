# frozen_string_literal: true

module LabwareCreators
  class TaggedPlate < Base
    include Form::CustomPage

    attr_reader :child

    self.page = 'tagged_plate'
    self.attributes = %i[
      api purpose_uuid parent_uuid user_uuid
      tag_plate_barcode tag_plate
      tag2_tube_barcode tag2_tube
    ]

    validates :api, :purpose_uuid, :parent_uuid, :user_uuid, :tag_plate_barcode, :tag_plate, presence: true
    validates :tag2_tube_barcode, :tag2_tube, presence: { if: :require_tag_tube? }

    QcableObject = Struct.new(:asset_uuid, :template_uuid)

    def tag_plate=(params)
      return nil if params.blank?
      @tag_plate = QcableObject.new(params[:asset_uuid], params[:template_uuid])
    end

    def tag2_tube=(params)
      return nil if params.blank?
      @tag2_tube = QcableObject.new(params[:asset_uuid], params[:template_uuid])
    end

    def initialize(*args, &block)
      super
      plate.populate_wells_with_pool
    end

    def substitutions
      @substitutions ||= {}
    end

    def tag_groups
      tag_collection.available
    end

    def tag2s
      tag2_collection.available
    end

    def tag2_names
      tag2_collection.names
    end

    def create_plate!
      api.transfer_template.find(transfer_template_uuid).create!(
        source: parent_uuid,
        destination: tag_plate.asset_uuid,
        user: user_uuid
      )

      yield(tag_plate.asset_uuid) if block_given?

      api.state_change.create!(
        user: user_uuid,
        target: tag_plate.asset_uuid,
        reason: 'Used in Library creation',
        target_state: 'exhausted'
      )

      # Convert plate instead of creating it
      @child = api.plate_conversion.create!(
        target: tag_plate.asset_uuid,
        purpose: purpose_uuid,
        user: user_uuid,
        parent: parent_uuid
      ).target

      true
    end

    def requires_tag2?
      plate.submission_pools.any? { |pool| pool.plates_in_submission > 1 }
    end

    #
    # Returns an array of acceptable source of tag2. The rules are as follows:
    # - If we don't need a tag2, allow anything, it doesn't matter.
    # - If we've already started using one method, enforce it for the rest of the pool
    # - Otherwise, anything goes
    # Note: The order matter here, as pools tagged with tubes will still list plates
    # for the i5 (tag) tag.
    #
    # @return [Array<String>] An array of acceptable sources, 'plate' and/or 'tube'
    def acceptable_tag2_sources
      return ['tube'] if require_tag_tube?
      return ['plate'] if tag_collection.used?
      ['tube', 'plate']
    end

    def tag2_field
      yield if allow_tag_tube?
      nil
    end

    def require_tag_tube?
      tag2_collection.used?
    end

    def allow_tag_tube?
      acceptable_tag2_sources.include?('tube')
    end

    def tag_plate_dual_index?
      return false if require_tag_tube?
      return true if tag_collection.used?
      nil
    end

    def help
      return 'single' unless requires_tag2?
      "dual_#{acceptable_tag2_sources.join('_')}"
    end

    private

    def tag_collection
      @tag_collection ||= LabwareCreators::Tagging::TagCollection.new(api, plate, purpose_uuid)
    end

    def tag2_collection
      @tag2_collection ||= LabwareCreators::Tagging::Tag2Collection.new(api, plate)
    end

    def create_labware!
      create_plate! do |plate_uuid|
        api.tag_layout_template.find(tag_plate.template_uuid).create!(
          plate: plate_uuid,
          user: user_uuid,
          substitutions: substitutions.reject { |_, new_tag| new_tag.blank? }
        )

        if tag2_tube_barcode.present?
          api.state_change.create!(
            user: user_uuid,
            target: tag2_tube.asset_uuid,
            reason: 'Used in Library creation',
            target_state: 'exhausted'
          )

          api.tag2_layout_template.find(tag2_tube.template_uuid).create!(
            source: tag2_tube.asset_uuid,
            plate: plate_uuid,
            user: user_uuid
          )
        end
      end
    end
  end
end
