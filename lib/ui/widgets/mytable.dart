import 'package:flutter/material.dart';

class MyTable extends StatefulWidget {
  final List<dynamic> columns;
  final List<List<dynamic>> rows;
  final List<List<dynamic>> totals;
  final Widget customTotals;
  final EdgeInsets padding;
  final Function delete;
  final bool showDeleteIcon;
  final Function onTap;
  final int indexCellKeyToReturnOnClick;
  final String colorColumn;
  final double fontSizeColumn;
  final bool isScrolled;
  final bool putDeleteIconOnlyOnTheFirstRow;
  MyTable({Key key, @required this.columns, @required this.rows, this.totals, this.customTotals, this.onTap, this.delete, this.showDeleteIcon = true, this.indexCellKeyToReturnOnClick = 0, this.padding = const EdgeInsets.only(bottom: 15, top: 15), this.isScrolled = true, this.colorColumn, this.fontSizeColumn, this.putDeleteIconOnlyOnTheFirstRow = false}) : super(key: key);
  @override
  _MyTableState createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  List<DataRow> rows;
  @override
  void initState() {
    // TODO: implement initState
    // _init();
    super.initState();
  }

  _onSelectChanged(dynamic data){
    if(widget.onTap != null)
      widget.onTap(data);
  }

  List<DataRow> _init(){
    rows = [];
    
    if(widget.rows == null)
      return [];

    if(widget.rows.length == 0)
      return [];

    for (var i = 0; i < widget.rows.length; i++) {
      List<DataCell> cells = [];
      var row = widget.rows[i];
      var firstDataToReturnOnChanged = row.first;

      for (var i2 = 1; i2 < row.length; i2++) {
        cells.add(DataCell((row[i2] is Widget) ? row[i2] : Text(row[i2], textAlign: TextAlign.center,)));
        //   DataRow dataRow = DataRow(
        //   onSelectChanged: (data){_onSelectChanged(firstDataToReturnOnChanged);},
        //   cells: row.map((e) => DataCell((e is Widget) ? e : Text(e, style: TextStyle(fontFamily: "GoogleSans"), textAlign: TextAlign.center,))).toList() 
        // );

        
      }

      if(widget.delete != null){
            cells.add(DataCell(Visibility(visible: (widget.putDeleteIconOnlyOnTheFirstRow == false) ? true : (widget.putDeleteIconOnlyOnTheFirstRow && i == 0), child: IconButton(icon: Icon(Icons.delete), onPressed: (){widget.delete(firstDataToReturnOnChanged);},))));
          // else{
          //   if(i == 0)
          //     cells.add(DataCell(IconButton(icon: Icon(Icons.delete), onPressed: (){widget.delete(firstDataToReturnOnChanged);},)));
          //   else

          // }
      }

      print("cells length: ${cells.length}");
      DataRow dataRow = DataRow(
        onSelectChanged: (data){_onSelectChanged(firstDataToReturnOnChanged);},
        cells: cells 
      );

      rows.add(dataRow);
    }

    // rows = widget.rows.map((row){
    //   var firstDataToReturnOnChanged = row.first;
    //   if(row.length > widget.columns.length)
    //     row.removeAt(0);

    //   DataRow dataRow = DataRow(
    //     onSelectChanged: (data){_onSelectChanged(firstDataToReturnOnChanged);},
    //     cells: row.map((e) => DataCell((e is Widget) ? e : Text(e, style: TextStyle(fontFamily: "GoogleSans"), textAlign: TextAlign.center,))).toList() 
    //   );

    //   if(widget.delete != null)
    //     dataRow.cells.add(DataCell(IconButton(icon: Icon(Icons.delete), onPressed: (){widget.delete(firstDataToReturnOnChanged);},)));
    //   return dataRow;
    // }).toList();

    List<DataRow> totals = getTotalsDataRow();
    if(totals != null)
      totals.forEach((element) {rows.add(element);});

    return rows;
    setState(() => rows = widget.rows.map((row) => DataRow(cells: row.map((string) => DataCell(Text(string, style: TextStyle(fontFamily: "GoogleSans"), textAlign: TextAlign.center,))).toList() )).toList());
    // _addTotalsToRows();
  }

  List<DataRow> getTotalsDataRow(){
    if(widget.totals == null)
      return null;
    
    if(rows.length == 0)
      return null;

    widget.rows.forEach((element) {element.forEach((element2) {print("MyTable _addTotalsToRows: ${element2}");});});
    // setState(() => rows.add(DataRow(cells: widget.totals.map((string) => DataCell(Text(string, style: TextStyle(fontSize: 15, fontFamily: "GoogleSans", fontWeight: FontWeight.w500), textAlign: TextAlign.center,))).toList() )) );   
    // return DataRow(cells: widget.totals.map((string) => DataCell(Text(string, style: TextStyle(fontSize: 17, fontFamily: "GoogleSans", fontWeight: FontWeight.w500), textAlign: TextAlign.center,))).toList() );
    var totalRows =  widget.totals.map((e){
      var cells = e.map<DataCell>((e2) => DataCell((e2 is Widget) ? e2 : Text(e2, style: TextStyle(fontSize: 17, fontFamily: "GoogleSans", fontWeight: FontWeight.w500), textAlign: TextAlign.center))).toList();
      return DataRow(cells: cells);
    }).toList();

    return totalRows;
  }

  _initColumn(){
    
    var columns =  widget.columns.map((e) => DataColumn(
      label: 
      (e is Widget) 
      ? 
      e 
      : 
      Text(e, style: TextStyle(fontFamily: "GoogleSans",), overflow: TextOverflow.ellipsis, softWrap: true, textAlign: TextAlign.center,)
    )).toList();
    if(widget.delete != null)
      columns.add(DataColumn(label: Center(child: (widget.showDeleteIcon) ? IconButton(icon: Icon(Icons.delete), onPressed: null,) : Text(""))));

    return columns;
  }

  _customTotals(){
    return (widget.customTotals != null) ? widget.customTotals : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    // return SingleChildScrollView(
    //   scrollDirection: Axis.horizontal,
    //   child: Column(
    //     children: [
    //       DataTable(
    //         showCheckboxColumn: false,
    //         columns: _initColumn(),
    //         rows: _init(),
    //       ),
    //       _customTotals(),
    //     ],
    //   ),
    // );
    return 
    (widget.isScrolled == false)
    ?
    //  Row(
    //    children: [
    //      Expanded(
    //        child: DataTable(
    //                   showCheckboxColumn: false,
    //                   columns: _initColumn(),
    //                   rows: _init(),
    //                 ),
    //      ),
    //    ],
    //  )
    DataTable(
      showCheckboxColumn: false,
      columns: _initColumn(),
      rows: _init(),
    )
    :
    Column(
      children: [
        // (widget.isScrolled)
        // ?
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:DataTable(
                showCheckboxColumn: false,
                columns: _initColumn(),
                rows: _init(),
              ),
          ),
          // :
          // DataTable(
          //       showCheckboxColumn: false,
          //       columns: _initColumn(),
          //       rows: _init(),
          //     )
          // ,
          _customTotals(),
      ],
    );
    
    
  }
}