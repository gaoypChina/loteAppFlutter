import 'package:flutter/material.dart';

_containershimer({@required context, @required double columnDivider, double height}){
  double width = MediaQuery.of(context).size.width;
  return Container(
    width: width / columnDivider,
    height: height,
  );
}

myPrincipalShimmerScreen({@required context}){
  return TabBarView(
            children: <Widget>[
              LayoutBuilder(
                builder:(context, BoxConstraints boxConstraints){ 
                  return ListView(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxHeight: (boxConstraints.maxHeight > 300) ? boxConstraints.maxHeight : 500),
                        child: Column(
                          children: <Widget>[
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _containershimer(context: context, columnDivider: 2, height: 10),
                                _containershimer(context: context, columnDivider: 2, height: 10),
                              ],
                            ),
                            

                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: _containershimer(context: context, columnDivider: 1, height: MediaQuery.of(context).size.height * 0.058)
                            ),
                            
                            SizedBox(height: 8,),
                            Row(
                              children: <Widget>[
                               _containershimer(context: context, columnDivider: 3, height: (MediaQuery.of(context).size.height * 0.0688)),
                               _containershimer(context: context, columnDivider: 3, height: (MediaQuery.of(context).size.height * 0.0688)),
                               _containershimer(context: context, columnDivider: 3, height: (MediaQuery.of(context).size.height * 0.0688)),
                               
                              ],
                            ),
                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                               
                                _containershimer(context: context, columnDivider: 5, height: 5),
                                _containershimer(context: context, columnDivider: 5, height: 5),
                                _containershimer(context: context, columnDivider: 5, height: 5),
                                _containershimer(context: context, columnDivider: 5, height: 5),
                                _containershimer(context: context, columnDivider: 5, height: 5),
                                      
                                    
                              ],
                            ),
                            
                            SizedBox(height: 8,),
                            Expanded(
                              // flex: 3,
                              flex: 3,
                              child: Container(
                                // color: Colors.red,
                                child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          _containershimer(context: context, columnDivider: 4, height: constraints.maxHeight / 5),
                                          _containershimer(context: context, columnDivider: 4, height: constraints.maxHeight / 5),
                                          _containershimer(context: context, columnDivider: 4, height: constraints.maxHeight / 5),
                                          _containershimer(context: context, columnDivider: 4, height: constraints.maxHeight / 5),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          _containershimer(context: context, columnDivider: 4, height: constraints.maxHeight / 5),
                                          _containershimer(context: context, columnDivider: 4, height: constraints.maxHeight / 5),
                                          _containershimer(context: context, columnDivider: 4, height: constraints.maxHeight / 5),
                                          _containershimer(context: context, columnDivider: 4, height: constraints.maxHeight / 5),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                         
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          // _buildButton(Text('0', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 2, 5),
                                          // _buildButton(Text('ENTER', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 2, 5),
                                          _containershimer(context: context, columnDivider: 2, height: constraints.maxHeight / 5),
                                          _containershimer(context: context, columnDivider: 2, height: constraints.maxHeight / 5),
                                        ],
                                      )
                                    ],
                                  );
                                }
                              ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _containershimer(context: context, columnDivider: 3, height: 10),
                                    _containershimer(context: context, columnDivider: 3, height: 10),
                                    _containershimer(context: context, columnDivider: 2, height: 10),

                                  ],
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 8,),
                  _containershimer(context: context, columnDivider: 1),
                ],
              ),
            ],
          );
        
}