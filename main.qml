import QtQuick 2.0
import QtQuick.Controls 2.0

ApplicationWindow{
    id: app
    visible: true
    width: 800
    height: 600
    color: '#ff8833'
    property int fs: app.width*0.03
    Column{
        spacing: 10
        width: parent.width
        Row{
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            height: buscador.height
            Text{
                id: labelBuscar
                text:'Buscar'
                font.pixelSize: app.fs
                anchors.verticalCenter: parent.verticalCenter
                color: 'white'
            }
            TextField{
                id: buscador
                font.pixelSize: app.fs
                width:app.width-labelBuscar.width-app.fs*2
                onTextChanged: actualizarLista()//tb.restart()
                focus: true
            }
        }
        Text{
            id: cant
            font.pixelSize: app.fs
        }
        ListView{
            id: lv
            model: lm
            delegate: del
            spacing: app.fs*0.5
            width: parent.width
            height: app.height-app.fs*2
            clip: true
            ListModel{
                id: lm
                function addProd(pid, pnom, pfecha, pprec, pprov){
                    return{
                        vid: pid,
                        vnom: pnom,
                        vfecha:pfecha,
                        vprec: pprec,
                        vprov: pprov
                    }
                }
            }
            Component{
                id: del
                Rectangle{
                    width: parent.width-app.fs*0.5
                    height: txt.contentHeight+app.fs
                    radius: app.fs*0.1
                    border.width: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: parseInt(vid)!==-10?'white':'red'
                    Text{
                        id: txt
                        color:parseInt(vid)!==-10?'black':'white'
                        font.pixelSize: app.fs
                        text: parseInt(vid)!==-10? '<b style="font-size:'+app.fs*1.4+'px;">'+vnom+'</b><br><b style="font-size:'+app.fs*1.4+'px;">Precio:</b> <span style="font-size:'+app.fs*2+'px;">$'+vprec+'</span> <b  style="font-size:'+app.fs*1.4+'px;">Fecha:</b><span style="font-size:'+app.fs*2+'px;">'+vfecha+'</span><br><b>Proveedor:</b>'+vprov :'<b>Resultados con palabra:</b> '+vnom
                        textFormat: Text.RichText
                        width: parent.width-app.fs
                        wrapMode: Text.WordWrap
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        var ac=unik.sqliteInit('productos.sqlite')
        console.log('BD conectada: '+ac)
    }
    function actualizarLista(){
        lm.clear()

        var p1=buscador.text.split(' ')
        lm.append(lm.addProd('-10', buscador.text, '', '',''))
        var b='nombre like \'%'
        for(var i=0;i<p1.length;i++){
            b+=p1[i]+'%'
        }
        b+='\' or nombre like \'%'
        for(i=p1.length-1;i>-1;i--){
            b+=p1[i]+'%'
        }
        b+='\''
        var sql='select distinct * from productos where '+b+''

        var rows=unik.getSqlData(sql)
        cant.text='Resultados: '+rows.length
        for(i=0;i<rows.length;i++){
            lm.append(lm.addProd(rows[i].col[0], rows[i].col[1], rows[i].col[2], rows[i].col[3], rows[i].col[4]))
        }



        //Busca por palabra
//        b=''
//        for(var i=0;i<p1.length-1;i++){
//            lm.append(lm.addProd('-10', p1[i], '', '',''))

//            sql='select distinct * from productos where nombre like \'%'+p1[i]+'%\''
//            var rows2=unik.getSqlData(sql)
//            for(var i2=0;i2<rows2.length;i2++){
//                lm.append(lm.addProd(rows2[i2].col[0], rows2[i2].col[1], rows2[i2].col[2], rows2[i2].col[3], rows2[i2].col[4]))
//            }
//        }
    }

}
