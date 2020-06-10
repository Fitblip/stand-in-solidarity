<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>
import ReconnectingWebSocket from 'reconnecting-websocket'

export default {
  name: 'App',
  mounted() {
    this.ws = new ReconnectingWebSocket(`${((window.location.protocol === 'https:') ? 'wss://' : 'ws://') + window.location.host}/ws/`);
    this.ws.onmessage = (message) => {
      this.$bus.$emit(message.data)
    }
    this.$bus.$on('heartbeat', () => {
      this.ws.send('heartbeat')
      this.$store.processed_beats += 1
    })

    setInterval(() => {
      this.ws.send('.')
    }, 10 * 1000)
  },
  methods: {
  },
  data() {
    return {
      ws: null,
    };
  },
};
</script>

<style lang="scss">
  @import '../node_modules/bulma/bulma';
  .timer{
    position: fixed;
    top: 0;
    right: 0;
    color: white;
    padding: 1rem;
    font-family: monospace;
  }
</style>
