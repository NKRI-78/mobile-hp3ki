import 'package:flutter/material.dart';

import 'package:flutter_mentions/flutter_mentions.dart';

class MentionPage extends StatefulWidget {
  const MentionPage({super.key});

  @override
  State<MentionPage> createState() => MentionPageState();
}

class MentionPageState extends State<MentionPage> {

  GlobalKey<FlutterMentionsState> key1 = GlobalKey<FlutterMentionsState>();

  List<GlobalKey<FlutterMentionsState>> keys = [];

  List<Widget> listmention = [];

  List<Map<String, dynamic>> data = [
    {
      'id': 'fdc784c6-d6ee-4409-b24d-cdd54fbb737b',
      'display': 'Fani',
      'photo': 'https://cdn.idntimes.com/content-images/duniaku/post/20191101/roronoa-zoro-smile-0078d7e8a33471cfbb5077358d7d21d5.jpg'
    },
    {
      'id': '6458ed26-40a8-4c61-a162-f5ffa57a32a3',
      'display': 'Udin',
      'photo':'https://media.hitekno.com/thumbs/2022/05/31/82987-one-piece-luffy/730x480-img-82987-one-piece-luffy.jpg'
    },
  ];

  List items = [
    {
      "id": 1,
      "content": "Summon @Udin dan @Fani"
    },
    {
      "id": 2,
      "content": "Summon @Udin"
    }
  ];
  
  @override 
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      key1.currentState?.controller?.text = 'test';
    });

    Future.delayed(const Duration(seconds: 2), () {
      // debugPrint(key1.currentState?.controller?.text.toString());
    });

    for (var item in items) {
      var i = items.indexOf(item);

      keys.add(GlobalKey<FlutterMentionsState>()); 

      setState(() {
        listmention.add(
          FlutterMentions(
            key: keys[i],
            suggestionPosition: SuggestionPosition.Top,
            onMentionAdd: (Map<String, dynamic> p0) {
              debugPrint(p0.toString());
            },
            onTap: () {
               
            },
            onSubmitted: (val) {
              debugPrint(val.toString());
            },
            onChanged: (val) {  
              debugPrint(val.toString());
            },
            onSearchChanged: (trigger, value) {
              debugPrint("$trigger$value");
            },
            enableSuggestions: false,
            readOnly: true,
            maxLines: 5,
            minLines: 1,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white
            ),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFF2F2F2F),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0)
                )
              ),
            ),
            mentions: [
              Mention(
                trigger: '@',
                style: const TextStyle(
                  color: Colors.blue,
                ),
                data: data,
                matchAll: false,
                suggestionBuilder: (Map<String, dynamic> data) {
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            data['photo'],
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          children: [
                            Text('@${data['display']}'),
                          ],
                        )
                      ],
                    ),
                  );
                }
              ),
            ]
          ),
        );
      });

      Future.delayed(const Duration(seconds: 1), () {
        keys[i].currentState?.controller?.text = item['content'];
      });
      
      Future.delayed(const Duration(seconds: 2), () {
        // debugPrint(keys[i].currentState?.controller?.text.toString());
      });
    }


  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [

            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          key1.currentState!.controller?.text = '@Fani ';
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            
                            Text('Fani',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0
                              ),
                            ),

                            Text('Lorem ipsum dolor sit amet',
                              style: TextStyle(
                                fontSize: 11.0
                              ),
                            ),

                            SizedBox(height: 5.0),

                            Text("Balas",
                              style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                              ),
                            ),

                          ],
                        )  
                      ),
                    ),

                    SizedBox(height: 10.0),

                    Container(
                      margin: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      child: FlutterMentions(
                        key: key1,
                        suggestionPosition: SuggestionPosition.Top,
                        onMentionAdd: (Map<String, dynamic> p0) {
                          debugPrint(p0.toString());
                        },
                        maxLines: 5,
                        minLines: 1,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF2F2F2F),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0)
                            )
                          ),
                        ),
                        mentions: [
                          Mention(
                            trigger: '@',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                            data: data,
                            matchAll: false,
                            suggestionBuilder: (Map<String, dynamic> data) {
                              return Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data['photo'],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Column(
                                      children: [
                                        Text('@${data['display']}'),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }
                          ),
                        ]
                      ),
                    ),

                    SizedBox(height: 10.0),

                    Container(
                      margin: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var mention in listmention) 
                            Container(
                              margin: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0
                              ),
                              child: mention
                            )
                        ],
                          
                      ),
                    )
                  ],
                ) 
              )
            )

          ],
        )
      )

    );
  }
}