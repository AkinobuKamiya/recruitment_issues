import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum type { tableOfContents, otherDevelopment }

class ContentsView extends StatelessWidget {
  const ContentsView({Key? key, required this.contentsType}) : super(key: key);

  final type contentsType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Markdown(
          data: contentsType == type.otherDevelopment
              ? markdownDataOtherDevelopment
              : tableOfContents,
        ));
  }
}

String tableOfContents = '''
- 画像を用いたカルーセル
- ボタンによるアニメーション
- Flutter公式サンプルの独自改変
- その他開発事例
''';

String markdownDataOtherDevelopment = '''
### 開発事例
- 通信系実装
  - httpによるピュア通信
  - retrofitによるREST通信
  - graphQLによる通信

- FCM実装
  - Firebase Messaging（Android、iOS)
    - Androidのネイティブコードにて受信後に音楽ファイルを自動再生させる機能を実装
  - Firebase Crashlytics（Android、iOS)
  - Firebase Remote Config(Android、iOS)
  
- GoogleMap実装
  - ライブラリを導入し、GPS情報を収集して軌跡の描画も実装
  - ピンの描画

- Push通知
  - APNsのPush通知実装
  - iOSのPushにて、Payload指定の着信音を鳴らす実装
  
- 内部データ保存について
  - SQLite実装
  - SharedPrefereneces実装
  
- ネイティブコードからFlutterへの換装経験
- Flutter1.xからFlutter2.xへの換装経験
- QRコード読取り機能実装
- ライブラリを用いたカレンダーカスタマイズ実装
- ライブアリを用いた音声の録音再生機能実装
''';
