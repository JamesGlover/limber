# frozen_string_literal: true

require_dependency 'form'

module LabwareCreators
  class Base
    module ClassMethods
      def class_for(purpose_uuid)
        Settings.purposes.fetch(purpose_uuid).fetch(:form_class).constantize
      end
    end
    extend ClassMethods

    include Form
    include PlateWalking

    self.attributes = %i[api purpose_uuid parent_uuid user_uuid transfer_templates]
    validates :api, :purpose_uuid, :parent_uuid, :user_uuid, presence: true

    class_attribute :default_transfer_template_name
    self.default_transfer_template_name = 'Transfer columns 1-12'

    attr_reader :plate_creation

    def plate_to_walk
      parent
    end

    def child
      plate_creation.try(:child) || :child_not_created
    end

    def child_purpose
      @child_purpose ||= api.plate_purpose.find(purpose_uuid)
    end

    def parent
      @parent ||= api.plate.find(parent_uuid)
    end
    alias plate parent

    def labware
      plate
    end

    # Purpose returns the plate or tube purpose of the labware.
    # Currently this needs to be specialised for tube or plate but in future
    # both should use #purpose and we'll be able to share the same method for
    # all presenters.
    def purpose
      labware.plate_purpose
    end

    def label_text
      "#{labware.label.prefix} #{labware.label.text}"
    end

    def save!
      raise StandardError, 'Invalid data; ' + errors.full_messages.join('; ') unless valid?
      create_labware!
    end

    def transfer_template_uuid
      transfer_templates_settings.uuid_for!(transfer_template_name)
    end

    private

    def create_plate_with_standard_transfer!
      @plate_creation = api.plate_creation.create!(
        parent: parent_uuid,
        child_purpose: purpose_uuid,
        user: user_uuid
      )

      api.transfer_template.find(transfer_template_uuid).create!(
        source: parent_uuid,
        destination: @plate_creation.child.uuid,
        user: user_uuid
      )

      yield(@plate_creation.child) if block_given?
      true
    end

    def transfer_template_name
      Settings.purposes.dig(purpose_uuid, :transfer_template) || default_transfer_template_name
    end

    def transfer_templates_settings
      transfer_templates || Limber::Application.config.transfer_templates
    end

    def create_labware!
      create_plate_with_standard_transfer!
    end
  end
end
