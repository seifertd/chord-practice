<template>
  <div class="container">
    <div class="row mt-1">
      <div class="col-12">
        <div class="card">
          <h6 class="card-header">Progress</h6>
          <div class="card-block" v-if="error">
            <error :error="error" />
          </div>
          <div class="card-block">
            <canvas id="progressChart"></canvas>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Axios from 'axios'
import Chart from 'chart.js'

const colors = "8dd3c7ffffb3bebadafb807280b1d3fdb462b3de69fccde5d9d9d9bc80bdccebc5ffed6f";
const getColor = (i, opacity) => {
  const realIndex = i % 12;
  const hex = colors.substring(realIndex*6,realIndex*6 + 6);
  return `rgba(${parseInt(hex.substring(0,2),16)},${parseInt(hex.substring(2,4),16)},${parseInt(hex.substring(4,6),16)},${opacity})`;
};
export default {
  name: 'progress',
  data() {
    return {
      error: null,
    };
  },
  created() {
    Axios.get('/progress.json').then( response => {
      const chartConfig = response.data.progress;
      let index = 0;
      chartConfig.data.datasets.forEach(dataSet => {
        dataSet.borderColor = getColor(index, 1.0);
        dataSet.backgroundColor = getColor(index, 0.3);
        index++;
      });
      const chart = new Chart("progressChart", chartConfig);
    }, error => {
      this.error = { heading: "Error loading page!", message: error.toString() };
    });
  }
}
</script>
