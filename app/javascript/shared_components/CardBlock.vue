<template>
  <div class="card-block" v-bind:class="{ 'bg-inverse': dark }">
    <slot>...</slot>
  </div>
</template>

<script>
export default {
  name: 'card-block',
  props: {
    dark: {
      type: Boolean,
      required: false,
      default: false
    }
  }
}
</script>
