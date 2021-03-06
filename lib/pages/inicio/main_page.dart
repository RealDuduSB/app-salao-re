import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sbs_app/pages/add%20service/addservice_page.dart';
import 'package:sbs_app/pages/filtro/filtropage.dart';
import 'package:sbs_app/pages/servicos/meus_servicos.dart';
import 'package:sbs_app/pages/userApp/user_page.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

CollectionReference services =
    FirebaseFirestore.instance.collection('services');

class _MainPageState extends State<MainPage> {
  final pageViewController = PageController();

  Future getServices() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("services").get();
    return qn.docs;
  }

  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }

  var search = 'cabe';

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                accountName: Text(
                  "Nome: " + widget.user.displayName,
                  style: GoogleFonts.lato(fontSize: 16),
                ),
                accountEmail: Text(
                  "email: " + widget.user.email,
                  style: GoogleFonts.lato(fontSize: 16),
                )),
            ListTile(
              leading: Icon(Icons.add_rounded, color: Colors.black),
              title: Text(
                "Adicionar servico",
                style: GoogleFonts.lato(fontSize: 27, color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddServicePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.article, color: Colors.black),
              title: Text("Meus servi??os",
                  style: GoogleFonts.lato(fontSize: 27, color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeusServicos()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text("Minha conta",
                  style: GoogleFonts.lato(fontSize: 27, color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FiltroPage()),
                );
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('services').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) return CircularProgressIndicator();

                List<DocumentSnapshot> docs = snapshot.data.docs.toList();

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () {},
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          docs[index].get('categoria'),
                                          style: GoogleFonts.lato(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(docs[index].get('especialidade'),
                                            style: GoogleFonts.lato(
                                              fontSize: 20,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      Text(docs[index].get('tempo') + "min",
                                          style: GoogleFonts.lato(
                                            fontSize: 20,
                                            color: Colors.black,
                                          )),
                                    ]),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.attach_money,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        Text(
                                            "R\$" +
                                                docs[index].get('valor') +
                                                ",00",
                                            style: GoogleFonts.lato(
                                              fontSize: 20,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          docs[index].get('cidade') + ", ",
                                          style: GoogleFonts.lato(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          docs[index].get('bairro'),
                                          style: GoogleFonts.lato(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )));
                  },
                );
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddServicePage()),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
