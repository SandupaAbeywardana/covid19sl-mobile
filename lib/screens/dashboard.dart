import 'package:covid19sl/models/hospitalData.dart';
import 'package:covid19sl/models/statistics.dart';
import 'package:covid19sl/screens/hospitalList.dart';
import 'package:covid19sl/services/http.dart';
import 'package:covid19sl/util/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  final HttpService httpService = HttpService();

  TabController tabController;
  HttpService _httpService = HttpService();
  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<Statistics>.value(value: _httpService.getData())
      ],
      child: Scaffold(
        body: Stack(children: <Widget>[
          Container(
            child: FutureBuilder<Statistics>(
              future: httpService.getData(),
              builder:
                  (BuildContext context, AsyncSnapshot<Statistics> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Could not fetch data');

                  case ConnectionState.waiting:
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 700,
                            child: Center(
                                child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.redAccent),
                            )),
                          ),
                        )
                      ],
                    );

                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('Error:\n\n${snapshot.error}');

                    //added a listView to temporary avoid overflow
                    return ListView(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: 50,
                            ),
                            Text('COVID-19 SL',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            IconButton(
                              icon: Icon(Icons.rotate_right),
                              onPressed: () {
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: TabBar(
                              controller: tabController,
                              indicatorColor: Colors.transparent,
                              labelColor: Colors.black,
                              unselectedLabelColor:
                                  Colors.grey.withOpacity(0.5),
                              isScrollable: false,
                              tabs: <Widget>[
                                Tab(
                                  child: Text('Local', style: tabStyle),
                                ),
                                Tab(child: Text('Global', style: tabStyle))
                              ],
                            )),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3, // this cause a overflow
                          child: TabBarView(
                            controller: tabController,
                            children: <Widget>[
                              // Local
                              Container(
                                padding: EdgeInsets.all(25),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      right: 25.0,
                                      top: 25.0,
                                      bottom: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Total Local Cases",
                                            style: overviewLabel,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.localTotalCases
                                                .toString(),
                                            style: totalCases,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        snapshot.data.localNewCases != 0
                                            ? '+' +
                                                snapshot.data.localNewCases
                                                    .toString() +
                                                ' new cases'
                                            : '',
                                        style: newCasesCount,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          // Local Deaths
                                          // Wrapped childs with expanded widgets to avoid overflow
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        snapshot
                                                            .data.localDeaths
                                                            .toString(),
                                                        style:
                                                            overviewStatsCount)
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Deaths",
                                                      style: overviewLabel,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),

                                          // Local Recovered
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        snapshot
                                                            .data.localRecovered
                                                            .toString(),
                                                        style:
                                                            overviewStatsCount)
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Recovered",
                                                      style: overviewLabel,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),

                                          // Local total in hospital
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        snapshot.data
                                                            .localTotalInHospitals
                                                            .toString(),
                                                        style:
                                                            overviewStatsCount)
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "In Hospitals",
                                                      style: overviewLabel,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              // Gloabl
                              Container(
                                height: 280,
                                padding: EdgeInsets.all(25),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      right: 25.0,
                                      top: 25.0,
                                      bottom: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Total Global Cases",
                                            style: overviewLabel,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.globalTotalCases
                                                .toString(),
                                            style: totalCases,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        snapshot.data.localNewCases != 0
                                            ? '+' +
                                                snapshot.data.globalNewCases
                                                    .toString() +
                                                ' new cases'
                                            : '',
                                        style: newCasesCount,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          SizedBox(width: 40),

                                          // Local Deaths
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                      snapshot.data.globalDeaths
                                                          .toString(),
                                                      style: overviewStatsCount)
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Deaths",
                                                    style: overviewLabel,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),

                                          SizedBox(width: 40),
                                          // Global Recovered
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                      snapshot
                                                          .data.globalRecovered
                                                          .toString(),
                                                      style: overviewStatsCount)
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Recovered",
                                                    style: overviewLabel,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),

                                          SizedBox(
                                            width: 40,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: <Widget>[

                        //   ],
                        // ),
                        Container(
                          alignment: Alignment(-0.9, -0.9),
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Hospital Data',
                            style: overviewLabel,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.48,
                          padding: EdgeInsets.all(12),
                          child: HospitalList(
                              hospitalData: snapshot.data.hospitalData),
                        )
                      ],
                    );

                  default:
                    return Text('ERROR');
                }
              },
            ),
          )
        ]),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DashboardState();
}
