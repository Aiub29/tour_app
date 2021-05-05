import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_app/colors/colors.dart';
import 'package:tour_app/providers/weather_provider.dart';
import 'package:geolocator/geolocator.dart' as Geo;
import 'package:geocoding/geocoding.dart' as GeoCoding;
import 'package:tour_app/styles/text_styles.dart';
import 'package:tour_app/utils/tour_utils.dart';
import 'package:tour_app/widgets/forecast_item.dart';
class WeatherPage extends StatefulWidget {
  static final routName= '/weather';
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isLoading=true;

  @override
  void didChangeDependencies() {
   _getDeviceLocation();
    super.didChangeDependencies();
  }
  _getDeviceLocation() async{
    final position = await Geo.getLastKnownPosition();
  //  print('${position.latitude},${position.longitude}');
  _getData(position);
  }
  _getData(Geo.Position position){
    Provider.of<WeatherProvider>(context,listen: false).getCurrentWeatherInfo(position)
        .then((_) {
      Provider.of<WeatherProvider>(context,listen: false).getForecastWeatherInfo(position).then((value) {
        setState(() {
          isLoading = false;
        });
      }).catchError((error) => throw error);
    }).catchError((error) => throw error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(icon: Icon(Icons.search),onPressed: (){
            showSearch(context: context, delegate:_CitySearchDelegate()).then((city) {

              if(city != null){
                //print(city);
               setState(() {
                 isLoading =true;
               });
               _getWeatherByCity( city);
              }
            });
          },),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset('images/weather.jpg',width: double.infinity,height: double.infinity,fit: BoxFit.cover,),
          ),
          Center(
            child: LayoutBuilder(
              builder: (context,constraint) =>
              Consumer<WeatherProvider>(
                  builder: (context,provider,_) =>
                      isLoading ? CircularProgressIndicator() :
                          constraint.maxWidth >600 ?
                              Row(
                                children: [
                                  Expanded(child: _buildCurrentSection(provider),),
                                  Expanded(child: Container(
                                    height: constraint.maxHeight / 3,
                                    child: _buildForecastSection(provider),
                                  )),
                                ],
                                
                              ) :
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 100,),
                                  Expanded(child: _buildCurrentSection(provider),),
                                  Spacer(),
                                  Expanded(child: _buildForecastSection(provider),),
                                ],
                              )
            ),
          ),
          ),
        ],
      ),
    );
  }

 Widget _buildCurrentSection(WeatherProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${provider.currentData.name}, ${provider.currentData.sys.country}',style: txtWhite30,),
        Text(getFormattedDate(provider.currentData.dt,'EEEE MMM dd yyyy'),style: txtWhite30,),
        Text('${provider.currentData.name}, ${provider.currentData.sys.country}',style: txtWhite30,),
        Text('${provider.currentData.main.temp.round()}\u00B0c',style: txtWhite30,),
        Text('Feels like: ${provider.currentData.main.feelsLike.round()}\u00B0c',style: txtWhite30,),

      ],
    );

  }

 Widget _buildForecastSection(WeatherProvider provider) {
return ListView.builder(
  scrollDirection: Axis.horizontal,
  itemBuilder: (context,index) => ForecastItem(provider.forecastData.list[index]),
  itemCount: provider.forecastData.list.length,
);

 }

  void _getWeatherByCity(String city) {
        GeoCoding.locationFromAddress(city).then((locations) {
         if(locations !=null && locations.length >0){
           double lat=locations[0].latitude;
           double lng=locations[0].longitude;
           final position =Geo.Position(latitude: lat, longitude: lng);
           _getData(position);
         }
        });

  }
}
class _CitySearchDelegate extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon:Icon(Icons.cancel),onPressed: (){
          query = '';
      },)

    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(icon:Icon(Icons.arrow_back),onPressed: (){
      close(context, null);
    },);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
    color: backgroundColor,
      child: ListTile(
        onTap: (){
          close(context, query);
        },
        leading: Icon(Icons.search),

        title: Text(query),
      ),


    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   var suggestionList = query == null ? cities :cities.where((city) => city.toLowerCase().
       startsWith(query.toLowerCase())).toList();
   return Container(
     color: backgroundColor,
     child: ListView.builder(
       itemBuilder: (context,index) =>
       ListTile(
         onTap: (){
           
           query = suggestionList[index];
           close(context, query);
         },
         title: Text(suggestionList[index]),
         ),
       itemCount: suggestionList.length,
     ),
   );

  }
  
}

