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
        });
    }
    if($('#reporte2-chart').length>0){
        $('#reporte2-chart').highcharts({
            title: {
            text: $("#reporte2-chart").data("text")
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
            name: $('#reporte2-chart').data("serie0name"),
            data: $('#reporte2-chart').data("data0")
        }]
        });
    }
        if($('#reporte3-chart').length>0){
        $('#reporte3-chart').highcharts({
            title: {
            text: $("#reporte3-chart").data("text")
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
            name: $('#reporte3-chart').data("serie0name"),
            data: $('#reporte3-chart').data("data0")
        }]
        });
    }
            if($('#reporte4-chart').length>0){
        $('#reporte4-chart').highcharts({
            title: {
            text: $("#reporte4-chart").data("text")
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
            name: $('#reporte4-chart').data("serie0name"),
            data: $('#reporte4-chart').data("data0")
        }]
        });
    }
            if($('#reporte5-chart').length>0){
        $('#reporte5-chart').highcharts({
            title: {
            text: $("#reporte5-chart").data("text")
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
            name: $('#reporte5-chart').data("serie0name"),
            data: $('#reporte5-chart').data("data0")
        }]
        });
    }
            if($('#reporte6-chart').length>0){
        $('#reporte6-chart').highcharts({
            title: {
            text: $("#reporte6-chart").data("text")
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
            name: $('#reporte6-chart').data("serie0name"),
            data: $('#reporte6-chart').data("data0")
        }]
        });
    }
    if($('#reporte7-chart').length>0){
        $('#reporte7-chart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Ventas vs. Quiebres por semana'
            },
            xAxis: {
                type: 'datetime',
                dateTimeLabelFormats: {
                week: '%e. %b'
            }
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Monto en CLP'
                },
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                    }
                }
            },
            legend: {
                align: 'right',
                x: -70,
                verticalAlign: 'top',
                y: 20,
                floating: true,
                backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
                borderColor: '#CCC',
                borderWidth: 1,
                shadow: false
            },
            // tooltip: {
            //     formatter: function() {
            //         return '<b>'+ ((this.x)/1000).to_datetime +'</b><br/>'+
            //             this.series.name +': '+ this.y +'<br/>'+
            //             'Total: '+ this.point.stackTotal;
            //     }
            // },
            plotOptions: {
                column: {
                    stacking: 'normal',
                    dataLabels: {
                        enabled: true,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                        style: {
                            textShadow: '0 0 3px black, 0 0 3px black'
                        }
                    }
                }
            },
            series: [{
                name: 'Quibres',
                data: $('#reporte7-chart').data("data0")

            }, {
                name: 'Despachados',
                data: $('#reporte7-chart').data("data1")

            }]
        
    });
    





    }
}; 
$(document).on('page:load',load_charts);
$(document).ready(load_charts);
