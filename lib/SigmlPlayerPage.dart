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
    'anna', 'marc', 'francoise', 'luna', 'siggi', 'robotboy', 'beatrice',
    'genie', 'otis', 'darshan', 'candy', 'max', 'carmen', 'monkey', 'dino',
    'dinoex', 'dinototo', 'bahia'
  ];

  // Variable holding the sigmlData (which can be dynamically assigned)
  late String sigmlData;

  @override
  void initState() {
    super.initState();
    sigmlData = '''<sigml>
    <hns_sign gloss="mug">
      <hamnosys_nonmanual>
        <hnm_mouthpicture picture="mVg"/>
      </hamnosys_nonmanual>
      <hamnosys_manual>
        <hamfist/> <hamthumbacrossmod/>
        <hamextfingerol/> <hampalml/>
        <hamshoulders/>
        <hamparbegin/> <hammoveu/> <hamarcu/>
        <hamreplace/> <hamextfingerul/> <hampalmdl/>
        <hamparend/>
      </hamnosys_manual>
    </hns_sign>
    <hns_sign gloss="take">
      <hamnosys_nonmanual>
        <hnm_mouthpicture picture="te_Ik"/>
      </hamnosys_nonmanual>
      <hamnosys_manual>
        <hamceeall/> <hamextfingerol/> <hampalml/>
        <hamlrbeside/> <hamshoulders/> <hamarmextended/>
        <hamreplace/> <hamextfingerl/> <hampalml/>
        <hamchest/> <hamclose/>
      </hamnosys_manual>
    </hns_sign>
    <hns_sign gloss="i">
      <hamnosys_nonmanual>
        <hnm_mouthpicture picture="a_I"/>
      </hamnosys_nonmanual>
      <hamnosys_manual>
        <hamfinger2/> <hamthumbacrossmod/>
        <hamextfingeril/> <hampalmr/>
        <hamchest/> <hamtouch/>
      </hamnosys_manual>
    </hns_sign>
    </sigml>''';
    _selectedAvatar = 'luna'; // Default avatar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SiGML Player'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(
                  'https://vhg.cmp.uea.ac.uk/tech/jas/vhg2022b/CWASA-plus-gui-panel.html',
                ),
              ),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(useHybridComposition: true),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStop: (controller, url) async {
                await _modifyPageDisplay();
                if (_selectedAvatar != null) {
                  _sendAvatarSelectionToWebView(_selectedAvatar!);
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          _buildPlaySiGMLButtons(),
          const SizedBox(height: 20),
          _buildAvatarDropdown(),
        ],
      ),
    );
  }

  Future<void> _modifyPageDisplay() async {
    await _webViewController.evaluateJavascript(source: '''
      (function() {
        try {
          Array.from(document.body.children).forEach((child) => {
            if (child.tagName.toLowerCase() !== 'table') {
              child.style.display = 'none';
            }
          });

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

  void _sendAvatarSelectionToWebView(String avatar) {
    _webViewController.evaluateJavascript(source: '''
      (function() {
        try {
          var avatarDropdown = document.querySelector(".menuAv.av0");
          if (avatarDropdown) {
            avatarDropdown.value = "$avatar";
            avatarDropdown.dispatchEvent(new Event('change'));
          }
        } catch (error) {
          console.error("Error selecting avatar:", error);
        }
      })();
    ''');

  }

  Widget _buildAvatarDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Select Avatar:'),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedAvatar,
          hint: const Text('Choose'),
          items: _avatars.map((avatar) {
            return DropdownMenuItem<String>(value: avatar, child: Text(avatar));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedAvatar = value;
              if (_selectedAvatar != null) {
                _sendAvatarSelectionToWebView(_selectedAvatar!);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Avatar "$_selectedAvatar" selected!'),
                  duration: const Duration(seconds: 2),
                ));
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildPlaySiGMLButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_selectedAvatar != null) {
              _injectSigmlTextToWebView(sigmlData);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please select an avatar first.'),
                duration: Duration(seconds: 2),
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            'Play SiGML Text',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _injectSigmlTextToWebView(String sigmlData) {
    _webViewController.evaluateJavascript(source: '''
      (function() {
        try {
          var sigmlTextarea = document.querySelector('.txtaSiGMLText.av0');
          if (sigmlTextarea) {
            sigmlTextarea.value = `$sigmlData`;
            sigmlTextarea.dispatchEvent(new Event('input'));

            var playButton = document.querySelector(".bttnPlaySiGMLText.av0");
            if (playButton) {
              playButton.click();
            }
          } else {
            console.error("SiGML textarea element not found.");
          }
        } catch (error) {
          console.error("Error injecting SiGML text:", error);
        }
      })();
    ''');

  }
}
