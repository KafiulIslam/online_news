import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String? imageUrl;
  final String? categoryName;
  final VoidCallback? onTap;

  const CategoryTile({Key? key, this.imageUrl, this.categoryName,this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imageUrl!,
                height: 65,
                width: 120,
                fit: BoxFit.cover,)
            ),
            Container(
              height: 65,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black26,
              ),
              child: Text(
                categoryName!,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
              ),
            )
          ],
        ),
      ),
    );
  }
}