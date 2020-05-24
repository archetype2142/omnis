import 'chart.js'

var ctx = document.getElementById('myChart').getContext('2d');
var myChart = new Chart(ctx, {
  type: 'bar',
  data: {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'Maj', 'Jun'],
    datasets: [{
      label: ['Total sales'],
      data: [12, 19, 3, 5, 2, 3],
      backgroundColor: [
      'rgba(255, 99, 132, 0.2)',
      'rgba(54, 162, 235, 0.2)',
      'rgba(255, 206, 86, 0.2)',
      'rgba(75, 192, 192, 0.2)',
      'rgba(153, 102, 255, 0.2)',
      'rgba(255, 159, 64, 0.2)'
      ],
      borderColor: [
      'rgba(255, 99, 132, 1)',
      'rgba(54, 162, 235, 1)',
      'rgba(255, 206, 86, 1)',
      'rgba(75, 192, 192, 1)',
      'rgba(153, 102, 255, 1)',
      'rgba(255, 159, 64, 1)'
      ],
      borderWidth: 1
    }]
  },
  options: {
    scales: {
      yAxes: [{
        ticks: {
          callback: function(value, index, values) {
            return value + ' mln';
          },
          beginAtZero: true
        }
      }]
    }
  }
});

var radar = document.getElementById('myChart2').getContext('2d');
var myRadarChart = new Chart(radar, {
  type: 'radar',
  data: {
    labels: ['Gloves', 'Mask', 'Hand Sanitizer', 'Soap', 'Pens'],
    datasets: [{
      label: ['last month'],
      data: [25, 10, 4, 2, 12]
    }, {
      backgroundColor: 'rgba(255, 159, 64, 0.5)',
      label: ['this month'],
      data: [10, 30, 18, 12, 30]
    }]
  },
  options: {
    scale: {
      angleLines: {
        display: true
      },
      ticks: {
        // suggestedMin: 50,
        // suggestedMax: 100
      }
    }
  }
});



