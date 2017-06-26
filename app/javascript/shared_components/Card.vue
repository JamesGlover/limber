<template>
  <div class="card">
    <h3 class="card-header" v-if="header">{{ header }}</h3>
    <slot>
      <card-block>...</card-block>
    </slot>
  </div>
</template>

<script>

import CardBlock from './CardBlock.vue'

export default {
  name: 'card',
  props: {
    header: {
      type: String,
      required: false
    }
  },
  components: {
    'card-block': CardBlock
  }
}
</script>
