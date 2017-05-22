# frozen_string_literal: true

module Robots
  class SharedBedRobot < Robot
    def bed_class(bed)
      bed[:secondary_purposes].present? ? Bed : Robot::Bed
    end
    private :bed_class
  end
end
