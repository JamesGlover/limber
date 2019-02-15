import Robots from './robots'
import { Bed, Car } from './bed_car'
import SharedPrograms from './shared_programs'

const IscPrograms = {
  nx8_pooling: {
    name() { return `Transfer 4x${this.parentA.purpose} => ${this.child.purpose}` },
    assets: {
      parentA: { location: Bed(2), initial_state: ['passed', 'qc_complete'] },
      parentB: { location: Bed(5), initial_state: ['passed', 'qc_complete'] },
      parentC: { location: Bed(3), initial_state: ['passed', 'qc_complete'] },
      parentD: { location: Bed(6), initial_state: ['passed', 'qc_complete'] },
      child: { location: Bed(4), initial_state: 'pending', target_state: 'passed' },
    },
    relationships: [
      { parent: 'parentA', child: 'child', parent_index: 0 },
      { parent: 'parentB', child: 'child', parent_index: 1 },
      { parent: 'parentC', child: 'child', parent_index: 2 },
      { parent: 'parentD', child: 'child', parent_index: 3 }
    ]
  }
}

export default [
  // The current configuration actually allows for a two state
  // transfer, although I'm not sure if this behaviour exists
  // in Limber. (I know we had permission to drop it)
  // If we re-implemented it I think we have two options:
  // 1) Two separate programs, with the first program having a function
  // to determine target state. (Before transfer one would lead to a
  // started state if there were more then 4 parents)
  // 2) Generate the robot CSV post scan based on the plates scanned in
  // and only pass the matching wells. A bigger change, but more powerful and
  // probably simpler in the long term.
  {
    robot: Robots.nx8,
    template: IscPrograms.nx8_pooling,
    assets: {
      parentA: { purpose: 'LB Lib PCR-XP' },
      parentB: { purpose: 'LB Lib PCR-XP' },
      parentC: { purpose: 'LB Lib PCR-XP' },
      parentD: { purpose: 'LB Lib PCR-XP' },
      child: { purpose: 'LB Shear' }
    }
  },
  {
    robot: Robots.nx8,
    template: SharedPrograms.stamp(Bed(2),Bed(4)),
    assets: {
      parent: { purpose: 'LB Lib PrePool' },
      child: { purpose: 'LB Hyb' }
    }
  },
  {
    robot: Robots.nx8,
    template: SharedPrograms.stamp(Bed(2),Bed(4)),
    assets: {
      parent: { purpose: 'LB Lib PrePool' },
      child: { purpose: 'LB Hyb' }
    }
  },
  {
    robot: Robots.bravo,
    template: SharedPrograms.stamp(Bed(4),Car(1,3)),
    assets: {
      parent: { purpose: 'LB Hyb' },
      child: { purpose: 'LB Cap Lib' }
    }
  },
  {
    robot: Robots.bravo,
    template: SharedPrograms.stamp(Bed(4),Car(4,5)),
    assets: {
      parent: { purpose: 'LB Cap Lib' },
      child: { purpose: 'LB Cap Lib PCR' }
    }
  },
  {
    robot: Robots.nx96,
    template: SharedPrograms.stamp(Bed(1),Bed(9)),
    assets: {
      parent: { purpose: 'LB Cap Lib PCR' },
      child: { purpose: 'LB Cap Lib PCR-XP' }
    }
  },
  {
    robot: Robots.nx8,
    template: SharedPrograms.stamp(Bed(4),Bed(2)),
    assets: {
      parent: { purpose: 'LB Cap Lib PCR-XP' },
      child: { purpose: 'LB Cap Lib Pool' }
    }
  },
]
