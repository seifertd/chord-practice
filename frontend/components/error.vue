<template>
  <div class="alert alert-danger" v-if="hasMessage" role="alert">
    <strong v-if="hasHeading">{{error.heading}}</strong> {{error.message}}
  </div>
</template>
<script>
export default {
  props: {
    error: { type: Object, default: {heading: null, message: null} }
  },
  computed: {
    hasHeading() {
      return this.error && this.error.heading && this.error.heading != "";
    },
    hasMessage() {
      return this.error && this.error.message && this.error.message != "";
    }
  }
}
</script>
