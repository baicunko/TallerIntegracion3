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
}; 
$(document).on('page:load',load_charts);
$(document).ready(load_charts);
