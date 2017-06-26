/* eslint no-console: 0 */

import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import CustomPooledTubes from './components/CustomPooledTubes.vue';

if (process.env.NODE_ENV == 'test') {
  // Vue generates warning if we aren't in the production environment
  // These clutter up the console, but we don't want to turn them off
  // everywhere as they may be useful if we ever end up accidentally
  // running production in development mode. Instead we turn them off
  // explicitly
  Vue.config.productionTip = false
}


document.addEventListener('DOMContentLoaded', () => {
  /*
   * Eventually this will get loaded as a component of a SPA, or at the very least
   * as part of a whole page Vue app.
   */
  if ( document.getElementById('custom-pooled-tubes-component') ) {

    Vue.use(BootstrapVue);

    /* The files-list element isn't on all pages. So only initialize our
    * Vue app if we actually find it */
    var app = new Vue({
      el: '#custom-pooled-tubes-component',
      render: h => h(CustomPooledTubes)
    });
  }
})
