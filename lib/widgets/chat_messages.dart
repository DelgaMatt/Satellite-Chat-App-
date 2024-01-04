import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // setting up a listener to the chat collection in the database, notifying the app, triggering build function so we can update the UI
      stream: FirebaseFirestore.instance
        .collection('chat')
        .orderBy('createdAt', descending: false)
        .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(child: Text('No messages found'));
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong..'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) =>
              Text(loadedMessages[index].data()['text']),
        );
      },
    );
  }
}