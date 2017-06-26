<template>
  <div class="row">
    <div class="content-main">
      <card>
        <card-block :dark="true">
          <plate></plate>
        </card-block>
      </card>
    </div>
    <div class="sidebar content-secondary">
      <card header="Pools">
        <card-block>Drag wells onto the tubes below</card-block>
      </card>
    </div>
  </div>
</template>

<script>

import Plate from '../../shared_components/Plate.vue'
import Card from '../../shared_components/Card.vue'
import CardBlock from '../../shared_components/CardBlock.vue'

export default {
  name: 'CustomPooledTubes',
  data () {
    return {}
  },
  components: {
    'plate': Plate,
    'card': Card,
    'card-block': CardBlock
  }
}
</script>
