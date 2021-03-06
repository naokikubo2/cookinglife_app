const workload_score = Number(document.getElementById('workload_score').textContent);
const healthy_score = Number(document.getElementById('healthy_score').textContent);

var ctx = document.getElementById('myChart');

var data = {
  labels: ["", ""],
  datasets: [{
    data: [workload_score, healthy_score],
    backgroundColor: ['rgba(255, 100, 100, 0.7)', 'rgba(30, 144, 244, 0.7)']
  }]
};

var options = {
  legend: {
    display: false
  },
  scales: {
    xAxes: [{
      ticks: {
        min: -4,
        max: 4,
        display: false
      }
    }]
  }
};

var ex_chart = new Chart(ctx, {
  type: 'horizontalBar',
  data: data,
  options: options
});
