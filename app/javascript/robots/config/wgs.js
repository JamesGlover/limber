import Robots from './robots'
import SharedPrograms from './shared_programs'
import { Bed } from './bed_car'

const WgsPrograms = {
  lib_pcr_purification: {
    name() { return `Transfer ${this.parentA.purpose} ➜ ${this.childA.purpose}` },
    assets: {
      parentA: { location: Bed(1), initial_state: 'passed' },
      childA: { location: Bed(9), initial_state: 'pending', target_state: 'passed' },
      parentB: { location: Bed(2), initial_state: 'passed' },
      childB: { location: Bed(10), initial_state: 'pending', target_state: 'passed' },
      parentC: { location: Bed(3), initial_state: 'passed' },
      childC: { location: Bed(11), initial_state: 'pending', target_state: 'passed' },
      parentD: { location: Bed(4), initial_state: 'passed' },
      childD: { location: Bed(12), initial_state: 'pending', target_state: 'passed' },
    },
    relationships: [
      { parent: 'parentA', child: 'childA' },
      { parent: 'parentB', child: 'childB' },
      { parent: 'parentC', child: 'childC' },
      { parent: 'parentD', child: 'childD' }
    ]
  }
}

export default [
  {
    robot: Robots.bravo,
    template: SharedPrograms.stamp(Bed(7),Bed(9)),
    assets: {
      parent: { purpose: 'LB Cherrypick' },
      child: { purpose: 'LB Shear' }
    }
  },
  {
    robot: Robots.bravo,
    template: SharedPrograms.stamp(Bed(9),Bed(7)),
    assets: {
      parent: { purpose: 'LB Shear' },
      child: { purpose: 'LB Post Shear' }
    }
  },
  {
    robot: Robots.bravo,
    template: SharedPrograms.stamp4to14start,
    assets: {
      parent: { purpose: 'LB Post Shear' },
      child: { purpose: 'LB End Prep' }
    }
  },
  {
    robot: Robots.bravo,
    template: SharedPrograms.bed7passed,
    assets: {
      plate: { purpose: 'LB End Prep' }
    }
  },
  {
    robot: Robots.bravo,
    template: SharedPrograms.stamp(Bed(7),Bed(6)),
    assets: {
      parent: { purpose: 'LB End Prep' },
      child: { purpose: 'LB Lib PCR' }
    }
  },
  {
    robot: Robots.bravo,
    template: WgsPrograms.lib_pcr_purification,
    assets: {
      parentA: { purpose: 'LB Lib PCR' }, childA: { purpose: 'LB Lib PCR-XP' },
      parentB: { purpose: 'LB Lib PCR' }, childB: { purpose: 'LB Lib PCR-XP' },
      parentC: { purpose: 'LB Lib PCR' }, childC: { purpose: 'LB Lib PCR-XP' },
      parentD: { purpose: 'LB Lib PCR' }, childD: { purpose: 'LB Lib PCR-XP' }
    }
  },
  {
    robot: Robots.zephyr,
    template: SharedPrograms.stamp(Bed(2),Bed(7)),
    assets: {
      parent: { purpose: 'LB Lib PCR' },
      child: { purpose: 'LB Lib PCR-XP' },
    }
  },
]
