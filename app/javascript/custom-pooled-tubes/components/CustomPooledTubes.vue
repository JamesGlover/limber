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
        <ul class="pool-list">
          <pool v-for="pool in pools"></pool>
          <new-pool></new-pool>
        </ul>
      </card>
    </div>
  </div>
</template>

<script>

import Plate from '../../shared_components/Plate.vue'
import Card from '../../shared_components/Card.vue'
import CardBlock from '../../shared_components/CardBlock.vue'

import Pool from './Pool.vue'
import NewPool from './NewPool.vue'

export default {
  name: 'CustomPooledTubes',
  data () {
    return {
      pools: [
        { wells: [{ location: 'F1', state: 'started' },{ location: 'H1', state: 'passed' }] },
        { wells: [{ location: 'A2', state: 'started' },{ location: 'B21', state: 'passed' }] }
      ]
    }
  },
  components: {
    'plate': Plate,
    'card': Card,
    'card-block': CardBlock,
    'pool': Pool,
    'new-pool': NewPool
  }
}
</script>
