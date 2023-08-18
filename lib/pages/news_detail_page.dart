import 'package:cryphive/model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {

  final News news;
  final index;

  const NewsDetailPage({
    super.key,
    required this.news,
    required this.index,
  });

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  @override
  Widget build(BuildContext context) {

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff090a13),
      body: ExtendedNestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled,) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              title: Text(
                widget.news.title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.index,
                  child: Image.network(
                    widget.news.urlToImage,
                    fit: BoxFit.fill,
                  ),
                ),
                centerTitle: true,
              ),
            )
          ];
        },
        pinnedHeaderSliverHeightBuilder: () => pinnedHeaderHeight,
        body: Card(
          borderOnForeground: true,
          elevation: 5,
          margin: const EdgeInsets.all(10),
          child: Container(
            color: const Color(0xff151f2c),
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Hero(
                    tag: '${widget.index}_title',
                    child: Text(
                      widget.news.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text(
                    'Published At: ${widget.news.publishedAt}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Hero(
                    tag: '${widget.index}_description',
                    child: Text(
                      widget.news.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    'Content',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    widget.news.content,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Divider(color: Colors.grey,),
                  const Text(
                    'For More Info:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  InkWell(
                    onTap: () async {
                      if(!await launchUrl(Uri.parse(widget.news.url))){
                        buildSnackError(
                          'Error Occurred',
                          context,
                          size,
                        );
                      }
                    },
                    child: Text(
                      widget.news.url,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }
}
