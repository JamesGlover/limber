# frozen_string_literal: true

module LabwareCreators
  # Allows the user to create custom pooled tubes.
  # THe user may create an arbitrary number of tubes, with a
  # 1 or more wells in each. An individual well may contribute
  # to more than one tube.
  class CustomPooledTubes < Base
    extend SupportParent::TaggedPlateOnly
    include Form::CustomPage

    self.page = 'custom_pooled_tubes'

    def create_labware!
      raise 'Not implemented'
    end

    def parent
      @parent ||= api.plate.find(parent_uuid)
    end

    # We may create multiple tubes, so cant redirect onto any particular
    # one. Redirecting back to the parent is a little grim, so we'll need
    # to come up with a better solution.
    # 1) Redirect to the transfer/creation and list the tubes that way
    # 2) Once tube racks are implemented, we can redirect there.
    def child
      parent
    end

    private

  end
end
