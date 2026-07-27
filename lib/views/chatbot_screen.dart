  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import '../core/constants/app_colors.dart';
  import '../viewmodels/chatbot_view_model.dart';

  
  class ChatBotScreen extends StatelessWidget {
    const ChatBotScreen({
      super.key,
    });

    @override
    Widget build(BuildContext context) {

      final vm =
          Provider.of<ChatBotViewModel>(
        context,
      );

      return Scaffold(
        backgroundColor: AppColors.bg,

        appBar: AppBar(
          backgroundColor:
              AppColors.bg,
          iconTheme:
              const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            "Vendor AI Assistant",
            style: TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          actions: [

        IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
          onPressed: () {

            vm.clearChat();
          },
        ),

      ],
        ),

        body: Column(
          children: [

            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.all(
                  12,
                ),
                itemCount:
                    vm.messages.length,

                itemBuilder:
                    (context, index) {

                  final msg =
                      vm.messages[index];

                  return Align(
                    alignment:
                        msg.isUser
                            ? Alignment
                                .centerRight
                            : Alignment
                                .centerLeft,

                    child: Container(
                      margin:
                          const EdgeInsets
                              .symmetric(
                        vertical: 6,
                      ),

                      padding:
                          const EdgeInsets
                              .all(12),

                      constraints:
                          const BoxConstraints(
                        maxWidth: 300,
                      ),

                      decoration:
                          BoxDecoration(
                        color: msg.isUser
                            ? Colors.blue
                            : AppColors.card,

                        borderRadius:
                            BorderRadius
                                .circular(
                          15,
                        ),
                      ),

                      child: Text(
                        msg.text,
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (vm.isLoading)
              const Padding(
                padding:
                    EdgeInsets.all(10),
                child:
                    CircularProgressIndicator(),
              ),

            Container(
              padding:
                  const EdgeInsets.all(
                12,
              ),
              color:
                  AppColors.card,

              child:Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: vm.messageController,

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      cursorColor: Colors.white,

                      decoration: InputDecoration(
                        hintText: "Ask Vendor AI...",

                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            25,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  CircleAvatar(
                    backgroundColor:
                        vm.isListening
                            ? Colors.red
                            : Colors.blue,

                    child: IconButton(
                      icon: Icon(
                        vm.isListening
                            ? Icons.mic
                            : Icons.mic_none,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        
                        if (vm.isListening) {

                          vm.stopListening();

                        } else {

                          vm.startListening(
                           vm.messageController,
                          );

                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                       vm.sendMessage();
                       
                      },
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      );
    }
  }