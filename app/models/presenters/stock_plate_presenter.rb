#This file is part of Illumina-B Pipeline is distributed under the terms of GNU General Public License version 3 or later;
#Please refer to the LICENSE and README files for information on licensing and authorship of this file.
#Copyright (C) 2011,2012 Genome Research Ltd.
module Presenters
  class StockPlatePresenter < PlatePresenter
    include Presenters::Statemachine

    self.authenticated_tab_states =  {
        :pending    =>  [ 'labware-summary-button' ],
        :started    =>  [ 'labware-summary-button' ],
        :passed     =>  [ 'labware-creation-button','labware-summary-button' ],
        :cancelled  =>  [ 'labware-summary-button' ],
        :failed     =>  [ 'labware-summary-button' ]
    }

    def control_state_change(&block)
      # You cannot change the state of the stock plate
    end

  end
end
