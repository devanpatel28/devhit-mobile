import 'package:devhit_mobile/helpers/size.dart';
import 'package:devhit_mobile/helpers/textStyle.dart';
import'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hovering/hovering.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'colors.dart';


Widget customCard(context,hei,wid,heading,count){
  double cWidth = wid;
  double cHeight = hei;
  return
    HoverAnimatedContainer(
      curve:Easing.standard,
      duration: Duration(milliseconds: 250),
      width: getWidth(context, cWidth),
      height: getHeight(context, cHeight),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      hoverDecoration: BoxDecoration(
        color: cardColor,
        border: Border(bottom: BorderSide(color: pallete2,width: 15)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Align(
                child: Text(heading,textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'MainReg',
                    fontSize: getSize(context, 1.2),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Text(count,
              style: TextStyle(
                fontFamily: 'MainReg',
                fontSize: getSize(context, 3.5),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
}

Widget customDivider(context,ind,upper,lower){
  return Column(
    children: [
      Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * (upper/100),
        decoration: BoxDecoration(
          color: Color(0x00FFFFFF),
        ),
      ),
      Row(
        children: [
          Expanded(
              child:Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black38],
                  ),
                ),
              )
          ),
          Expanded(
              child:Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black38,Colors.transparent, ],
                  ),
                ),
              )
          ),
        ],
      ),
      Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * (lower/100),
        decoration: BoxDecoration(
          color: Color(0x00FFFFFF),
        ),
      ),
    ],
  );
}

Widget custProfCardUser(context,String str,IconData ico,PageAddress){
  return InkWell(
    onTap: (){Get.to(PageAddress);},
    child: Column(
      children: [
        Container(
          height: getHeight(context,0.17),
          width: getWidth(context, 0.35),
          decoration: BoxDecoration(
              color: pallete1,
              borderRadius: BorderRadius.circular(15),

          ),
          child: Icon(ico, size: getSize(context, 13),color: pallete4,),
        ),
        SizedBox(height: 10,),
        Text(str,style: primaryStyleBold(context, pallete4, 3.5),)
      ],
    ),
  );
}
Widget custProfCardAdmin(context,String str,fontSize,IconData ico,PageAddress){
  return InkWell(
    onTap: (){Get.to(PageAddress);},
    child: Container(
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(25),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ico, size: getSize(context, 10),color: pallete4,),
          SizedBox(height: 15,),
          Text(str,style: primaryStyleBold(context, pallete4, 2.5),textAlign: TextAlign.center,)
        ],
      ),
    ),
  );
}

Widget customButton(context,buttonTitle,buttonIco,forgroundColor,backgroundColor,pageAddress){
  return InkWell(
    onTap: (){Get.to(pageAddress);},
    child: HoverAnimatedContainer(
      curve: Easing.standard,
      height: getHeight(context, 0.06),
      width: getWidth(context, 0.15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      hoverDecoration: BoxDecoration(color: backgroundColor,borderRadius: BorderRadius.circular(10),border: Border(bottom: BorderSide(width: 4 ,color: orangeColor2),right: BorderSide(width: 4,color: orangeColor2))),

      child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Row(
          children: [
            Icon(buttonIco,size: getSize(context, 1.8),color: forgroundColor,),
            SizedBox(width: 20,),
            Text(buttonTitle,style: primaryStyleBold(context, forgroundColor, 1.1),textAlign: TextAlign.center,)
          ],
        ),
      ),
    ),
  );
}

Widget customHeading(context,title)
{
  return Padding(
    padding: const EdgeInsets.only(top: 10,bottom: 10),
    child: Row(
      children: [
        Expanded(
            child:Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black38],
                ),
              ),
            )
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(title.toString().toUpperCase(),style: primaryStyleBold(context, pallete4, 3)),
        ),
        Expanded(
            child:Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black38,Colors.transparent, ],
                ),
              ),
            )
        ),
      ],
    ),
  );
}

Widget customHeading2(context,title)
{
  return Padding(
    padding: const EdgeInsets.only(top: 5,bottom: 5),
    child: Row(
      children: [
        Expanded(
            child:Container(
              height: 1,
              width: 10,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black26],
                ),
              ),
            )
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(title.toString().toUpperCase(),style: primaryStyleBold(context, pallete4, 3)),
        ),
        Expanded(
            child:Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black26,Colors.transparent],
                ),
              ),
            )
        ),
      ],
    ),
  );
}

Widget contactFooter(context)
{
  return Column(
    children: [
      customHeading(context, "Contact Us"),
      Container(
        width: double.infinity,
        height: getHeight(context, 0.5),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [pallete0,pallete1],
                begin: Alignment.topCenter,
                end:Alignment.bottomCenter
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: getHeight(context, 0.45),
                width: getWidth(context, 0.4),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 250,
                        width: 10,
                        decoration: BoxDecoration(color: pallete4),
                      ),
                      Container(
                        height: 200,
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Corporate Office",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: pallete4,
                              fontFamily: "MainReg",
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Shree Hari Developers,\n3rd floor,\nIsckon Mall,\n150 feet ring road,\nRajkot 360001\n+91 76000 00090",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: pallete4,
                              fontFamily: "MainReg",
                              fontSize: 20,

                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
            ),
            Container(
                height: getHeight(context, 0.45),
                width: getWidth(context, 0.50),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 280,
                        width: 10,
                        decoration: BoxDecoration(color: pallete4),
                      ),
                      Container(
                        height: 200,
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Inquiry",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: pallete4,
                              fontFamily: "MainReg",
                              fontSize: getSize(context, 2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Container(
                                width: getWidth(context, 0.2),
                                height: getHeight(context, 0.065),
                                decoration: BoxDecoration(
                                    color: pallete1,
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextField(
                                  style: TextStyle(fontSize: getSize(context, 1.1),fontFamily: "MainReg"),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                      hintText: "Name",
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: getWidth(context, 0.2),
                                height: getHeight(context, 0.065),
                                decoration: BoxDecoration(
                                    color: pallete1,
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(fontSize: getSize(context, 1.1),fontFamily: "MainReg"),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                      hintText: "Mobile Number",
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: getWidth(context, 0.41),
                            height: getHeight(context, 0.13),
                            decoration: BoxDecoration(
                                color: pallete1,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                              minLines: 5,
                              maxLines: 10,
                              style: TextStyle(fontSize: getSize(context, 1.1),fontFamily: "MainReg"),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                  hintText: "Comments (If any)",
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          HoverButton(
                            onpressed: (){
                              Get.snackbar("Inquiry","Thank you! for Contacting Us !",
                                backgroundColor: pallete4,
                                colorText: pallete0,
                                snackPosition: SnackPosition.BOTTOM,
                                maxWidth: getWidth(context, 0.3),
                              );
                            },
                            color: pallete4,
                            textColor: pallete1,
                            height: 40,
                            minWidth: 150,
                            hoverShape:ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5)) ,
                            child: Text("SUBMIT",style: TextStyle(fontFamily: "MainReg")),
                            shape: ContinuousRectangleBorder(side: BorderSide(color: pallete4),borderRadius: BorderRadius.circular(5)),
                            elevation: 0,
                            hoverElevation: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    ],
  );
}

Widget loadingBar(context,double cHeight,double cWidth,Color color)
{
  return SkeletonAnimation(
    curve: Curves.ease,
      child: Container(
        height: getHeight(context, cHeight),
        width: getWidth(context, cWidth),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(getSize(context, 1.5))
        ),
      )
  );
}

Widget customLoading(double size)
{
  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height:double.infinity,
          width: double.infinity,
          color: Colors.black12,
        ),
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(20)
          ),
        ),
        LoadingAnimationWidget.fourRotatingDots(
          color: pallete2,
          size: (size/3)*1.5,
        ),
      ],
    ),
  );
}

Widget customNoData(context,String msg)
{
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset("assets/images/no-document.png",height: 80,opacity: const AlwaysStoppedAnimation(.8),),
      SizedBox(height: 15,),
      Text(msg,style: primaryStyle(context, pallete4, 4),)
    ],
  );
}
