<template>
  <table class="plate-view mx-auto">
    <thead>
      <tr>
        <th v-for="column in width">{{ column }}</th>
        <th class="first-col">&nbsp;</th>
      </tr>
    </thead>

    <tbody>
      <draggable :element="'tr'"
                 v-for="(row, row_index) in rows"
                 :options="{
                  draggable:'td',
                  disabled: !draggableWells,
                  sort: false,
                  group:{ name:'wells',  pull:'clone', put:false }}"
                  :list="wellMatrix[row_index]"
                 ><td v-for="well in wellMatrix[row_index]" class="col-all"><well v-bind="well"></well></td>
                 <th class="first-col" slot="footer">{{ row }}</th>
      </draggable>
    </tbody>

  </table>
</template>

<script>

import Well from './Well.vue'
import Draggable from 'vuedraggable'

export default {
  name: 'plate',
  data () {
    return {
      width: 12,
      height: 8,
      wells: [
        { location: 'A1', state: 'passed' },
        { location: 'B1', state: 'failed' },
        { location: 'C1', state: 'started' }
      ]
    }
  },
  props: {
    draggableWells: {
      type: Boolean,
      required: false,
      default: true
    }
  },
  computed: {
    // Uses the plate height to generate row names
    rows: function () {
      var rows = [];
      for ( var i = 0;  i < this.height; i++) {
        rows.push(String.fromCharCode(65+i));
      }
      return rows;
    },
    // Takes the wells and indexes them by location
    wellHash: function() {
      var well_hash = {};
      for (let well of this.wells) {
        well_hash[well.location] = well
      };
      return well_hash;
    },
    wellMatrix: function() {
      var matrix = []
      for (let row of this.rows) {
        var row_wells = []
        for ( var column = 1; column <= this.width; column ++) {
          row_wells.push(this.wellAt(row, column));
        }
        matrix.push(row_wells);
      }
      return matrix;
    }
  },
  components: {
    'well': Well,
    draggable: Draggable
  },
  methods: {
    wellAt: function (row, column) {
      return this.wellHash[row + column] || { location: row + column, state: 'empty' };
    }
  }
}
</script>
