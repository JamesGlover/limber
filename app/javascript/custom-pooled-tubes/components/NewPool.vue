<template>
  <li><draggable :options="{group:{ name:'wells', put:false}}" class="new-pool" @add="onAdd" :list="wells">+ New tube</draggable></li>
</template>

<script>

import Draggable from 'vuedraggable'

export default {
  name: 'NewPool',
  data () {
    return {
      wells: []
    }
  },
  components: {
    draggable: Draggable
  },
  methods: {
    onAdd: function(index, element) {
      console.log(index);
    }
  }
}
</script>
