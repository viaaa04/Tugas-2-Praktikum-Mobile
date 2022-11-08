import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'countries_model.dart';
import 'covid_data_source.dart';

class PageGridCountries extends StatefulWidget {
  const PageGridCountries({Key? key}) : super(key: key);
  @override
  _PageGridCountriesState createState() => _PageGridCountriesState();
}
class _PageGridCountriesState extends State<PageGridCountries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card List Countries"),
      ),
      body: _buildGridCountriesBody(),
    );
  }
  Widget _buildGridCountriesBody() {
    return Container(
      child: FutureBuilder(
        future: CovidDataSource.instance.loadCountries(),
        builder: (
            BuildContext context,
            AsyncSnapshot<dynamic> snapshot,
            ) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            CountriesModel countriesModel =
            CountriesModel.fromJson(snapshot.data);
            return _buildSuccessSection(countriesModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }
  Widget _buildErrorSection() {
    return Text("Error");
  }
  Widget _buildEmptySection() {
    return Text("Empty");
  }
  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget _buildSuccessSection(CountriesModel data) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemCount: data.countries?.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
                child: Center(
                  child : Padding(
                  padding: const EdgeInsets.all(15.0),
                    child: _buildItemCountries("${data.countries?[index].name} \n (${data.countries?[index].iso3})"),
                ),
                ),
              );
            }, // return _buildItemCountries("${data.countries?[index].name} \n ${data.countries?[index].iso3}");
    );
  }
  Widget _buildItemCountries(String value) {
    return Text(value, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold));
  }
}