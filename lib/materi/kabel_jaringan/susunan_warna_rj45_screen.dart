import 'package:flutter/material.dart';
import 'straight_crossover_screen.dart';
class SusunanWarnaRj45Screen extends StatelessWidget { const SusunanWarnaRj45Screen({super.key}); static const Color p=Color(0xFF5D4037), d=Color(0xFF3E2723), l=Color(0xFFF3ECE9), g=Color(0xFF607D8B), b=Color(0xFFDCE3EA);
 @override Widget build(BuildContext c)=>Scaffold(backgroundColor:const Color(0xFFF7F9FB),appBar:AppBar(backgroundColor:Colors.white,foregroundColor:const Color(0xFF263238),elevation:0,leading:IconButton(icon:const Icon(Icons.arrow_back_rounded),onPressed:()=>Navigator.pop(c)),title:const Text('Kabel Jaringan',style:TextStyle(fontSize:17,fontWeight:FontWeight.w700)),actions:[_badge('04 / 08')],bottom:_prog(.5)),body:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.fromLTRB(20,24,20,32),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[_head(),const SizedBox(height:25),_rj45Diagram(),const SizedBox(height:26),_title('Urutan T568B yang sering digunakan'),const SizedBox(height:12),_pinList(),const SizedBox(height:22),_info(),const SizedBox(height:28),_nav(c)]))));
 PreferredSizeWidget _prog(double v)=>PreferredSize(preferredSize:const Size.fromHeight(3),child:Container(height:3,alignment:Alignment.centerLeft,child:FractionallySizedBox(widthFactor:v,child:Container(color:p)))); Widget _badge(String x)=>Container(margin:const EdgeInsets.only(right:16),padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),decoration:BoxDecoration(color:l,borderRadius:BorderRadius.circular(8)),child:Text(x,style:const TextStyle(color:p,fontSize:12,fontWeight:FontWeight.w700))); Widget _head()=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:5),decoration:BoxDecoration(color:p,borderRadius:BorderRadius.circular(6)),child:const Text('MATERI 04',style:TextStyle(color:Colors.white,fontSize:11,fontWeight:FontWeight.w700))),const SizedBox(height:14),const Text('RJ45 dan Susunan\nWarna Kabel',style:TextStyle(color:d,fontSize:29,fontWeight:FontWeight.w800,height:1.12)),const SizedBox(height:12),const Text('Memahami konektor RJ45 dan urutan warna yang digunakan saat terminasi kabel twisted pair.',style:TextStyle(color:g,fontSize:15,height:1.55))]); Widget _rj45Diagram() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: b),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        const Icon(Icons.settings_input_component_rounded, size: 44, color: p),
        const SizedBox(height: 10),
        const Text('RJ45', style: TextStyle(color: d, fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        const Text(
          'Konektor 8P8C yang umum digunakan untuk kabel Ethernet.',
          textAlign: TextAlign.center,
          style: TextStyle(color: g, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 14),
        Container(
          height: 26,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: l, borderRadius: BorderRadius.circular(6)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (i) => Text(
              '${i + 1}',
              style: const TextStyle(color: p, fontSize: 10, fontWeight: FontWeight.w800),
            )),
          ),
        ),
      ],
    ),
  );
Widget _title(String x)=>Text(x,style:const TextStyle(color:Color(0xFF263238),fontSize:16,fontWeight:FontWeight.w800)); Widget _pinList()=>Column(children:[_item(1,'Putih-Oranye',Colors.orange),_item(2,'Oranye',Colors.orange.shade700),_item(3,'Putih-Hijau',Colors.green),_item(4,'Biru',Colors.blue),_item(5,'Putih-Biru',Colors.blue.shade200),_item(6,'Hijau',Colors.green.shade700),_item(7,'Putih-Cokelat',Colors.brown.shade300),_item(8,'Cokelat',Colors.brown)]); Widget _item(int n,String name,Color color)=>Container(margin:const EdgeInsets.only(bottom:7),padding:const EdgeInsets.symmetric(horizontal:12,vertical:10),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:b),borderRadius:BorderRadius.circular(8)),child:Row(children:[Container(width:27,height:27,alignment:Alignment.center,decoration:BoxDecoration(color:color.withOpacity(.14),borderRadius:BorderRadius.circular(6)),child:Text('$n',style:TextStyle(color:color,fontWeight:FontWeight.w900,fontSize:11))),const SizedBox(width:10),Expanded(child:Text(name,style:const TextStyle(color:d,fontSize:12.5,fontWeight:FontWeight.w700))) ])); Widget _info()=>Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:l,borderRadius:BorderRadius.circular(10)),child:const Text('Catatan: susunan warna harus konsisten pada kedua ujung kabel sesuai kebutuhan. Pemasangan yang rapi membantu mengurangi kesalahan saat pengujian.',style:TextStyle(color:g,fontSize:12.5,height:1.5))); Widget _nav(BuildContext c)=>Row(children:[Expanded(child:OutlinedButton.icon(onPressed:()=>Navigator.pop(c),icon:const Icon(Icons.arrow_back_rounded,size:18),label:const Text('Sebelumnya'),style:OutlinedButton.styleFrom(minimumSize:const Size(0,48),foregroundColor:g,side:const BorderSide(color:b)))),const SizedBox(width:12),Expanded(child:ElevatedButton.icon(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const StraightCrossoverScreen())),icon:const Icon(Icons.arrow_forward_rounded,size:18),label:const Text('Berikutnya'),style:ElevatedButton.styleFrom(minimumSize:const Size(0,48),backgroundColor:p,foregroundColor:Colors.white,elevation:0))) ]); }
