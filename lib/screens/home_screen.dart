import 'package:flutter/material.dart';
import 'package:flutter_google_docs_clone/colors.dart';
import 'package:flutter_google_docs_clone/common/widget/loading.dart';
import 'package:flutter_google_docs_clone/models/document_model.dart';
import 'package:flutter_google_docs_clone/repository/auth_repository.dart';
import 'package:flutter_google_docs_clone/repository/document_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void signOut(WidgetRef ref) {
      ref.read(authRepositoryProvider).signOut();
      ref.read(userProvider.notifier).update((state) => null);
    }

    void createDocument(BuildContext context, WidgetRef ref) async {
      String token = ref.read(userProvider)!.token;
      final navigator = Routemaster.of(context);
      final snackbar = ScaffoldMessenger.of(context);

      final errorModel =
          await ref.read(documentRepositoryProvider).createDocument(token);

      if (errorModel!.data != null) {
        navigator.push('/document/${errorModel.data.id}');
      } else {
        snackbar.showSnackBar(
          SnackBar(
            content: Text(errorModel.error!),
          ),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kWhiteColor,
          actions: [
            IconButton(
                onPressed: () => createDocument(context, ref),
                icon: const Icon(
                  Icons.add,
                  color: kBlackColor,
                )),
            IconButton(
                onPressed: () => signOut(ref),
                icon: const Icon(
                  Icons.logout,
                  color: kRedColor,
                ))
          ],
        ),
        body: FutureBuilder(
          future: ref
              .watch(documentRepositoryProvider)
              .getDocumentByMe(ref.watch(userProvider)!.token),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }

            return Center(
              child: Container(
                width: 600,
                margin: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {
                      DocumentModel? document = snapshot.data!.data[index];
                      return InkWell(
                        onTap: () => Routemaster.of(context)
                            .push('/document/${document.id}'),
                        child: SizedBox(
                          height: 50,
                          child: Card(
                            child: Center(
                              child: Text(
                                document!.title,
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          },
        ));
  }
}
