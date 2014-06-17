var load_charts;
load_charts =function(){
    if($('#reporte-chart').length>0){
        $('#reporte-chart').highcharts({
            title: {
            text: $("#reporte-chart").data("text")
        },
            xAxis: {
            type: 'datetime'
        },
            yAxis: {
            title: {
            text: 'Cantidad'
        }
        },   
        
        series: [{
            name: $('#reporte-chart').data("serie0name"),
            data: $('#reporte-chart').data("data0")
        }]
        //     chart: {
        //         // type: 'bar'
        //         type: $("#reporte-chart").data("type"),
        //         height: 300
        //     },
        //     title: {
        //         // text: 'Fruit Consumption'
        //         text: $("#reporte-chart").data("text"),
        //         align: 'left'
        //     },
        //     xAxis: {
        //         // categories: ['Apples', 'Bananas', 'Oranges']
        //         type: 'datetime',
        //         dateTimeLabelFormats: { // don't display the dummy year
        //                              month: '%b %e, %Y'
        //                         },
        //          // tickInterval: 2678400000
        //        minTickInterval: 3600*24*30*1000,//time in milliseconds
        //         minRange: 3600*24*30*1000,
        //         ordinal: false, //this sets the fixed time formats
        //     minPadding: 0.05,
        //     maxPadding: 0.05
        //     },
        //     yAxis: {
        //         title: {
        //             // text: 'Fruit eaten'
        //             text: $("#reporte-chart").data("ytitle") 
        //         },
        //         max: 100,
        //         min: 0

        //     },
        //     legend: {
        //     layout: 'vertical',
        //     floating: true,
        //     backgroundColor: '#FFFFFF',
        //     align: 'left',
        //     verticalAlign: 'top',
        //     y: 20,
        //     x: 50
        //     },
        //     tooltip: {
        //             headerFormat: '<b>{series.name}</b><br>',
        //             pointFormat: '{point.x:%e. %b}: {point.y:.2f} %'
        //         },        
        //     series: [{
        //         name: 'Ideal',
        //         data: $('#reporte-chart').data("data0"),
        //         marker: {
        //             enabled: false
        //         }
        //     }, {
        //         name: 'Real',
        //         data: $('#reporte-chart').data("data1"),
        //         marker: {
        //             enabled: false
        //         }
        //     }]
        });
    }
}; 
$(document).on('page:load',load_charts);
$(document).ready(load_charts);
