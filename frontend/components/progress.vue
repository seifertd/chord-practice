<template>
  <div class="container">
    <div class="row mt-1">
      <div class="col-12">
        <div class="card">
          <h6 class="card-header">Progress</h6>
          <div class="card-block" v-if="error">
            <error :error="error" />
          </div>
          <div class="card-block" v-if="!error">
            <p>FUCKY FOO!</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'progress',
}
</script>
