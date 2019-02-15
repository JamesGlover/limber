
import { Bed } from './bed_car'

// Exports shared program templates, which can be imported into other pipeline
// workflows. Keep keys short but descriptive, as they will be used to reference
// the program template in each program configuration.
// eg.
//  key : { // Used to identify the program template when setting up a program
//    name() {}, // Function that returns a user-friendly robot name
//    sameRobot: false, // Validates plate is place on the same robot used last
//    assets: { // Object describing each asset which will be loaded on the robot
//      asset_key: { // An identifier for the asset, match the same name in the
//                   // program configuration
//        location: Bed(1), // The bar/carousel on which the plate is placed
//        initial_state: 'pending', // The state in which the plate should be at start
//        target_stae: 'passed' // The state the plate gets transitioned to (if any)
//      }
//    },
//   relationships: [ // An array of relationship objects
//     { parent: 'parent_key', child: 'child_key', parent_index: 0 }
//     // parent_key and child_key refer to the keys used in the assets section
//     // above.
//     // Indexes can be configured for one-many, many-one relationships
//     // parent_index: the parent must be the nth parent of the child
//     // child_index: the child must be the nth child of the parent
//   ]
// }

export default {
  // Simple function to generate the common stamping behaviour
  stamp(source, destination) {
    return {
      name() { return `Transfer ${this.parent.purpose} ➜ ${this.child.purpose}` },
      assets: {
        parent: { location: source, initial_state: 'passed' },
        child: { location: destination, initial_state: 'pending', target_state: 'passed' }
      },
      relationships: [{ parent: 'parent', child: 'child' }]
    }
  },
  stamp4to14start: {
    name() { return `Transfer ${this.parent.purpose} ➜ ${this.child.purpose}` },
    assets: {
      parent: { location: Bed(4), initial_state: 'passed' },
      child: { location: Bed(14), initial_state: 'pending', target_state: 'started' }
    },
    relationships: [{ parent: 'parent', child: 'child' }]
  },
  bed7passed: {
    name() { return `${this.plate.purpose}` },
    sameRobot: true,
    assets: {
      plate: { location: Bed(7), initial_state: 'started', target_state: 'passed' }
    }
  }
}
