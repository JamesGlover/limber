# frozen_string_literal: true

module LabwareCreators::SupportParent
  # Adds a class method which flags only plates as suitable parents
  # This is used to work out is we should render the link
  module PlateOnly
    extend ActiveSupport::Concern

    class_methods do
      def support_parent?(parent)
        parent.plate?
      end
    end

    def parent
      @parent ||= api.plate.find(parent_uuid)
    end
  end
end
