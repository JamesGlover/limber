<template>
  <b-card>
    <h3>{{ name }}</h3>
    <ul>
      <li v-for="asset in assets">{{ asset.location.name }}: {{ asset.purpose }}</li>
    </ul>
  </b-card>
</template>

<script>

  export default {
    name: 'RobotSummary',
    data () { return {} },
    props: {
      config: { type: Object, required: true }
    },
    methods: {},
    computed: {
      name() {
        try {
          const programName = this.config.template.name.call(this.config.assets)
          return `${this.config.robot.name}: ${programName}`
        }
        catch(error) {
          // If the robot is misconfigured name generation may be invalid.
          console.log('Title generation error', error, this.config)
          return 'Invalid name'
        }
      },
      assets() {
        return Object.keys(this.config.assets).map((key)=>{
          return {...this.config.template.assets[key], ...this.config.assets[key]}
        })
      }
    },
    components: {}
  }
</script>
