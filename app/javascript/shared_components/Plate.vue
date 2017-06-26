<template>
  <table class="plate-view mx-auto">
    <thead>
      <tr>
        <th class="first-col">&nbsp;</th>
          <th v-for="column in width">{{ column }}</th>
      </tr>
    </thead>

    <tbody>
      <tr v-for="row in rows">
        <th class="first-col">{{ row }}</th>
        <td v-for="column in width" class="col-all">
          <well></well>
        </td>
      </tr>
    </tbody>

  </table>
</template>

<script>

import Well from './Well.vue'

export default {
  name: 'plate',
  data () {
    return {
      width: 12,
      height: 8,
      wells: {}
    }
  },
  computed: {
    rows: function () {
      var rows = [];
      for ( var i = 0;  i < this.height; i++) {
        rows.push(String.fromCharCode(65+i));
      }
      return rows;
    }
  },
  components: {
    'well': Well
  }
}
</script>
