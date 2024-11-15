import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SigmlPlayerPage extends StatefulWidget {
  final String sigmlData;

  SigmlPlayerPage({required this.sigmlData});

  @override
  _SigmlPlayerPageState createState() => _SigmlPlayerPageState();
}

class _SigmlPlayerPageState extends State<SigmlPlayerPage> {
  late InAppWebViewController _webViewController;
  String? _selectedAvatar;

  final List<String> _avatars = [
    'anna', 'marc', 'francoise', 'luna', 'siggi',
    'robotboy', 'beatrice', 'genie', 'otis', 'darshan',
    'candy', 'max', 'carmen', 'monkey', 'dino',
    'dinoex', 'dinototo', 'bahia'
  ];

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
                _sendSigmlData(widget.sigmlData);
                if (_selectedAvatar != null) {
                  _sendAvatarSelectionToWebView(_selectedAvatar!);
                }
              },
              onLoadError: (controller, url, code, message) {
                print("Load error: $message");
              },
            ),
          ),
          SizedBox(height: 10),
          _buildAvatarDropdown(),
        ],
      ),
    );
  }

  Future<void> _modifyPageDisplay() async {
    await _webViewController.evaluateJavascript(source: '''
      (function() {
        try {
          var bodyElements = document.body.children;
          for (var i = 0; i < bodyElements.length; i++) {
            var element = bodyElements[i];
            if (element.tagName.toLowerCase() !== 'table') {
              element.style.display = 'none';
            }
          }
          
          var table = document.querySelector('table');
          if (table) {
            table.style.display = 'table';
            var firstTd = table.querySelector('td:first-child');
            if (firstTd) {
              firstTd.style.width = '100vw';
              firstTd.style.height = '100vh';
              firstTd.style.overflow = 'hidden';
              firstTd.style.display = 'block';
            }
            
            var lastTd = table.querySelector('td:last-child');
            if (lastTd) {
              lastTd.style.display = 'none';
            }
          }
        } catch (error) {
          console.error("Error modifying page display:", error);
        }
      })();
    ''');
  }

  void _sendSigmlData(String sigmlData) {
    _webViewController.evaluateJavascript(source: '''
      (function() {
        try {
          var sigmlTextarea = document.querySelector(".txtaSiGMLText.av0");
          var playButton = document.querySelector(".bttnPlaySiGMLText.av0");

          if (sigmlTextarea && playButton) {
            sigmlTextarea.value = `$sigmlData`;
            playButton.click();
          } else {
            console.log("SiGML textarea or play button not found.");
          }
        } catch (error) {
          console.error("Error sending SiGML data:", error);
        }
      })();
    ''');
  }

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
            _sendAvatarSelectionToWebView(value);
          }
        },
      ),
    );
  }

  void _sendAvatarSelectionToWebView(String avatar) {
    _webViewController.evaluateJavascript(source: '''
      (function() {
        try {
          var avatarDropdown = document.querySelector("select.menuAv.av0");
          if (avatarDropdown) {
            avatarDropdown.value = "$avatar";
            avatarDropdown.dispatchEvent(new Event('change'));
          } else {
            console.log("Avatar selector not found.");
          }
        } catch (error) {
          console.error("Error selecting avatar:", error);
        }
      })();
    ''');
  }
}
