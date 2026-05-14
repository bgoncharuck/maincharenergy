import 'package:maincharenergy/src/service/get_it.dart';
import 'package:puppeteer/puppeteer.dart';

/// works!
/// goes into the page
/// finds what needed
/// goes there
/// goes through pagination 7 times
Future<void> testPuppeteer() async {
  final browser = await puppeteer.launch(
    executablePath:
        '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    // if console - must be true
    // if need to see browser - false
    headless: false,
    userDataDir: './browser_cache',
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-gpu',
    ],
  );
  final tab = await browser.newPage();
  await tab.setUserAgent(
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
  );

  try {
    // Use a massive timeout so the 'goto' future never "explodes"
    // and destroys the page context while we are working.
    final navigationFuture = tab.goto(
      loginData.loginUrl,
      timeout: const Duration(days: 10),
    );

    await Future.any([
      navigationFuture,
      tab.waitForSelector(
        'a[href="/blog"]',
        timeout: const Duration(seconds: 15),
      ),
    ]);

    // find hyperlink to  newspaper
    var hyperlink = await tab.$OrNull('a[href="/blog"]');
    if (hyperlink == null) {
      throw Exception('Hyperlink to /news not found');
    }

    // default timeout is 30, if you need to test it
    await Future<void>.delayed(const Duration(seconds: 1));
    await hyperlink.click();

    // Pagination: follow "next" up to 7 times.
    for (var i = 0; i < 6; i++) {
      try {
        await tab.waitForSelector(
          'a[rel="next"]',
          timeout: const Duration(seconds: 15),
        );
      } catch (_) {
        print('link not found');
        break;
      }
      hyperlink = await tab.$OrNull(
        'a[rel="next"]',
      );
      if (hyperlink == null) {
        print('link not found');
        break;
      }
      await Future<void>.delayed(const Duration(seconds: 1));
      await hyperlink.click();
    }

    // see result
    await Future<void>.delayed(const Duration(seconds: 10));
    // ignore: empty_catches
  } catch (e) {
  } finally {
    await browser.close();
  }
}
