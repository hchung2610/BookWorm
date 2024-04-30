import 'package:flutter/material.dart';
import 'package:practice_proj/dictionary-related/api.dart';
import 'package:practice_proj/dictionary-related/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DictionaryTab extends StatefulWidget {
  final String? initialWord;
  DictionaryTab({Key? key, this.initialWord}) : super(key: key);

  @override
  _DictionaryTabState createState() => _DictionaryTabState();
}

class _DictionaryTabState extends State<DictionaryTab> {
  bool inProgress = false;
  ResponseModel? responseModel;
  String noDataText = "Welcome, Start searching";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialWord != null) {
      searchController.text = widget.initialWord!;
      _getMeaningFromApi(widget.initialWord!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary Lookup"),
      ),
      body: Column(
        children: [
          _buildSearchWidget(),
          Expanded(child: responseModel != null ? _buildResponseWidget() : _noDataWidget()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: responseModel != null ? () => _saveWord(searchController.text) : null,
        child: Icon(Icons.save),
        backgroundColor: responseModel != null ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }

  void _saveWord(String word) async {
    if (word.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      print(prefs.getStringList('words'));
      List<String> existingWords = prefs.getStringList('words') ?? [];
      if (!existingWords.contains(word)) {
        existingWords.add(word);
        await prefs.setStringList('words', existingWords);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Word saved!'))
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Word already exists!'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot save an empty word!'))
      );
    }
  }

  _buildResponseWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          responseModel!.word!,
          style: TextStyle(
            color: Colors.purple.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(responseModel!.phonetic ?? ""),
        const SizedBox(height: 16),
        Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _buildMeaningWidget(responseModel!.meanings![index]);
              },
              itemCount: responseModel!.meanings!.length,
            ))
      ],
    );
  }

  _buildMeaningWidget(Meanings meanings) {
    String definitionList = "";
    meanings.definitions?.forEach(
          (element) {
        int index = meanings.definitions!.indexOf(element);
        definitionList += "\n${index + 1}. ${element.definition}\n";
      },
    );

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meanings.partOfSpeech!,
              style: TextStyle(
                color: Colors.orange.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Definitions : ",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(definitionList),
            _buildSet("Synonyms", meanings.synonyms),
            _buildSet("Antonyms", meanings.antonyms),
          ],
        ),
      ),
    );
  }

  _buildSet(String title, List<String>? setList) {
    if (setList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(setList!
              .toSet()
              .toString()
              .replaceAll("{", "")
              .replaceAll("}", "")),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _noDataWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          noDataText,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  _buildSearchWidget() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(hintText: "Search word here"),
      onSubmitted: (value) {
        _getMeaningFromApi(value);
      },
    );
  }

  _getMeaningFromApi(String word) async {
    setState(() {
      inProgress = true;
    });
    try {
      ResponseModel? fetchedResponse = await API.fetchMeaning(word);
      if (fetchedResponse != null && fetchedResponse.meanings != null && fetchedResponse.meanings!.isNotEmpty) {
        responseModel = fetchedResponse;
        noDataText = "Word found. You can save it now.";
      } else {
        responseModel = null;
        noDataText = "Meaning cannot be fetched";
        _showInvalidWordAlert();
      }
    } catch (e) {
      responseModel = null;
      noDataText = "Meaning cannot be fetched";
      _showInvalidWordAlert();
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }

  void _showInvalidWordAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invalid Word"),
          content: Text("The word you searched for doesn't have a valid meaning. Please try another word."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
