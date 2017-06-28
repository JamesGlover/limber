<template>
  <li>
    <draggable :options="{group:'wells'}" :element="'tr'" class="pool"  :list="wells">
      <td v-for="well in wells"><well v-bind="well" :label="true"></well></td>
    </draggable>
  </li>
</template>

<script>


import Well from '../../shared_components/Well.vue'
import Draggable from 'vuedraggable'

export default {
  name: 'Pool',
  data () {
    return {
      wells: [{location:'H12',state:'failed'}]
    }
  },
  components: {
    well: Well,
    draggable: Draggable
  }
}
</script>

