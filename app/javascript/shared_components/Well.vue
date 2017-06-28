<template>
  <div class="well">
    <div
    id="aliquot_"
    class="aliquot col-all"
    v-bind:class="state"
    rel=""
    data-pool="">
      <p v-if="label">{{ location }}</p>
    </div>
  </div>
</template>

<script>

export default {
  name: 'well',
  data () {
    return {}
  },
  props: {
    label: {
      type: Boolean,
      required: false,
      default: false
    },
    location: {
      type: String,
      required: true
    },
    state: {
      type: String,
      required: true
    }
  }
}
</script>

<style scoped>
  .well {
    height:36px;
    width:36px;
    text-align: center;
    overflow: hidden;
    background: $gray-lighter;
  }
</style>
