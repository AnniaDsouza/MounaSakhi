import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SigmlPlayerPage extends StatefulWidget {
  final String sigmlFileName;

  SigmlPlayerPage({required this.sigmlFileName});

  @override
  _SigmlPlayerPageState createState() => _SigmlPlayerPageState();
}

class _SigmlPlayerPageState extends State<SigmlPlayerPage> {
  late InAppWebViewController _webViewController;
  String? _selectedAvatar; // Store the selected avatar

  final List<String> _avatars = [
    'anna', 'marc', 'francoise', 'luna', 'siggi',
    'robotboy', 'beatrice', 'genie', 'otis', 'darshan',
    'candy', 'max', 'carmen', 'monkey', 'dino',
    'dinoex', 'dinototo', 'bahia'
  ]; // Avatar options from the dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SiGML Player'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri('https://vhg.cmp.uea.ac.uk/tech/jas/vhg2022b/CWASA-plus-gui-panel.html'),
              ),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(useHybridComposition: true),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStop: (controller, url) async {
                await _modifyPageDisplay();
                _sendSigmlFile(widget.sigmlFileName);
              },
              onLoadError: (controller, url, code, message) {
                print("Load error: $message");
              },
            ),
          ),
          SizedBox(height: 10),
          _buildAvatarDropdown(), // Dropdown for avatar selection
        ],
      ),
    );
  }

  Future<void> _modifyPageDisplay() async {
    await _webViewController.evaluateJavascript(source: '''
      var bodyElements = document.body.children;
      for (var i = 0; i < bodyElements.length; i++) {
        var element = bodyElements[i];
        if (element.tagName.toLowerCase() !== 'table') {
          element.style.display = 'none'; // Hide all except table
        }
      }

      var table = document.querySelector('table');
      if (table) {
        table.style.display = 'table';
      }

      var lastTd = table.querySelectorAll('td:last-child');
      if (lastTd.length > 0) {
        lastTd[lastTd.length - 1].style.display = 'none';
      }

      var firstTd = table.querySelector('td:first-child');
      if (firstTd) {
        firstTd.style.width = '100vw';
        firstTd.style.height = '100vh';
        firstTd.style.overflow = 'hidden';
        firstTd.style.display = 'block';
      }

      console.log(document.body.innerHTML);
    ''');
  }

  void _sendSigmlFile(String fileName) {
    String sigmlData = fileName; // Use the provided SiGML data

    // Inject JavaScript to update the page with SiGML data
    _webViewController.evaluateJavascript(source: '''
      document.getElementById("sigml_input").value = `$sigmlData`;
      document.getElementById("submit_button").click();
    ''');
  }

  // Dropdown for avatar selection
  Widget _buildAvatarDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        value: _selectedAvatar,
        hint: Text("Select Avatar"),
        isExpanded: true,
        items: _avatars.map((avatar) {
          return DropdownMenuItem<String>(
            value: avatar,
            child: Text(avatar),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedAvatar = value;
          });
          if (value != null) {
            _sendAvatarSelectionToWebView(value); // Send the selected avatar to the WebView
          }
        },
      ),
    );
  }

  // Send the selected avatar value to the WebView
  void _sendAvatarSelectionToWebView(String avatar) {
    _webViewController.evaluateJavascript(source: '''
      var avatarDropdown = document.querySelector("select.menuAv.av0");
      if (avatarDropdown) {
        avatarDropdown.value = "$avatar"; // Set the avatar dropdown value
        avatarDropdown.dispatchEvent(new Event('change')); // Trigger change event
      } else {
        console.log("Avatar selector not found");
      }
    ''');
  }
}


// <sigml>

// 	<hns_sign gloss="hello">
// 		<hamnosys_nonmanual>
// 			<hnm_mouthpicture picture="hVlU"/>
// 		</hamnosys_nonmanual>
// 		<hamnosys_manual>
// 			<hamflathand/>
// 			<hamthumboutmod/>
// 			<hambetween/>
// 			<hamfinger2345/>
// 			<hamextfingeru/>
// 			<hampalmd/>
// 			<hamshouldertop/>
// 			<hamlrat/>
// 			<hamarmextended/>
// 			<hamswinging/>
// 			<hamrepeatfromstart/>
// 		</hamnosys_manual>
// 	</hns_sign>

// </sigml>