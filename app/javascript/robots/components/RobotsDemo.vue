<template>
  <lb-page>
    <lb-main-content>
      <lb-robot-summary v-for="program in programs" :config="program">
      </lb-robot-summary>
    </lb-main-content>
    <lb-sidebar>
      <p>These robots have all been loaded in via the config</p>
    </lb-sidebar>
  </lb-page>
</template>

<script>

  import RobotSummary from './RobotSummary'

  export default {
    name: 'RobotsDemo',
    data () {
      return {
      }
    },
    props: {
      programs: { type: Array, required: true }
    },
    methods: {},
    computed: {},
    components: {
      'lb-robot-summary': RobotSummary,
    }
  }
</script>
