import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_news_app/controller/constant/image_path.dart';


class BlogTile extends StatelessWidget {
  final String? imageUrl, title, description;
  final VoidCallback? onTap;
  const BlogTile({Key? key, this.imageUrl, this.title, this.description,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(children: [
          _image(context),
          const SizedBox(height: 8,),
          Text(title!,textAlign: TextAlign.start,style: GoogleFonts.roboto(
            textStyle: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w800),
          ),),
          const SizedBox(height: 4,),
          Text(description!,textAlign: TextAlign.start,style: GoogleFonts.notoSans(
            textStyle: const TextStyle(color: Colors.black,fontSize: 14,),
          )),
        ],),
      ),
    );
  }

 Widget _image(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(generalNews,height: 200,width: double.infinity,fit: BoxFit.cover,)),
      ),
    );
 }

}