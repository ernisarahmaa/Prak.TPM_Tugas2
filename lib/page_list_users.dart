import 'package:flutter/material.dart';
import 'package:pertemuan6prak/api_data_source.dart';
import 'package:pertemuan6prak/page_detail_user.dart';
import 'package:pertemuan6prak/users_model.dart';

class PageListUsers extends StatefulWidget {
  const PageListUsers({Key? key}) : super(key: key);

  @override
  State<PageListUsers> createState() => _PageListUsersState();
}

class _PageListUsersState extends State<PageListUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List dari User'),
      ),
      body: _buildListUsersBody(),
    );
  }

  Widget _buildListUsersBody() {
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadUsers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic>snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            UsersModel usersModel = UsersModel.fromJson(snapshot.data);
            return _buildSuccessSection(usersModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return const Text("ERROR");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(UsersModel data) {
    return ListView.builder(
      itemCount: data.data!.length,
      itemBuilder: (context, index) {
        return _buildItemUsers(data.data![index]);
      },
    );
  }

  Widget _buildItemUsers(Data userData) {

    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageDetailUser(idUser: userData.id!)
          )
      ),
      child: Card(
        child: Row(
          children: [
            Container(
              width: 100,
              child: Image.network(userData.avatar!),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userData.firstName! + " " + userData.lastName!),
                Text(userData.email!)
              ],
            )
          ],
        ),
      ),
    );
  }
}
