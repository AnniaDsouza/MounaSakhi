import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SigmlPlayerPage extends StatefulWidget {
  final String sigmlFileName;

  SigmlPlayerPage({required this.sigmlFileName});

  @override
  _SigmlPlayerPageState createState() => _SigmlPlayerPageState();
}

class _SigmlPlayerPageState extends State<SigmlPlayerPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition for Android
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SiGML Player'),
        backgroundColor: Colors.black,
      ),
      body: WebView(
        initialUrl: 'assets/local_sigml_player.html', // Path to your HTML file
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onPageFinished: (url) {
          // Send the SiGML data to the player after the page loads
          _sendSigmlFile(widget.sigmlFileName);
        },
      ),
    );
  }

  void _sendSigmlFile(String fileName) {
    // Here is where you'd load your SiGML file. Since we're passing a static example,
    // you can adjust this to load actual file content.
    String sigmlData = '''
      <sigml>
        <hns_sign gloss="one">
          <hamnosys_nonmanual/>
          <hamnosys_manual>
            <hamfinger2/>
            <hamthumbacrossmod/>
            <hamextfingeru/>
            <hampalmu/>
            <hamchest/>
            <hamclose/>
            <hammoveo/>
            <hamsmallmod/>
          </hamnosys_manual>
        </hns_sign>
      </sigml>
    '''; 

    // Inject JavaScript to update the HTML file with SiGML data and trigger animation
    _webViewController.runJavascript(
      '''
      document.getElementById("sigml_input").value = `$sigmlData`;
      document.getElementById("submit_button").click();
      '''
    );
  }
}
