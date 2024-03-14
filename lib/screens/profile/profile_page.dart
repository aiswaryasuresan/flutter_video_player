import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff555555),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 400,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Column(
                  children: [
                    SizedBox(height: 70,),
                    _datafield(data: 'Aiswarya K K',icon: Icons.person),
                    SizedBox(height: 20,),
                    _datafield(data: '11.07.1997', icon: Icons.calendar_month),
                    SizedBox(height: 20,),
                    _datafield(data: 'sample@gmail.com', icon: Icons.mail
                    )
                  ],
                ),
              )
            ],
          ),
          CustomPaint(
            painter: HeaderCurvedContainer(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 35,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://img.fixthephoto.com/blog/images/gallery/news_preview_mob_image__preview_11368.png'),
                  ),
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(bottom: 270, left: 184),
          //   child: CircleAvatar(
          //     backgroundColor: Colors.black54,
          //     child: IconButton(
          //       icon: Icon(
          //         Icons.edit,
          //         color: Colors.white,
          //       ),
          //       onPressed: () {},
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class _datafield extends StatelessWidget {
  final String data;
  final IconData icon;
  const _datafield({
    super.key,
    required this.data,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
          height: 60,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.amber,
                ),
                SizedBox(width: 10),
                Text(
                  data,
                  style: TextStyle(
                    letterSpacing: 2,
                    color: Colors.black54,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5))),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff555555);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}



