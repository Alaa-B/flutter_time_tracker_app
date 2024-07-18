import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'entries_bloc.dart';
import 'entries_list_tile.dart';
import '../jobs/list_items_builder.dart';
import '../../../services/database.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({super.key});

  static Widget create(BuildContext context) {
    final database = Provider.of<DataBase>(context);
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(database: database),
      child: const EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context, listen: false);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        // debugPrint(snapshot.error.toString());

        return ListItemsBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
