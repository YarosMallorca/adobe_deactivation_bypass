import 'package:adobe_deactivation_bypass/bypass.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final ArgParser argParser = ArgParser();
  argParser.addFlag('apply',
      abbr: 'a', negatable: false, help: 'Apply the patch');
  argParser.addFlag('remove',
      abbr: 'r', negatable: false, help: 'Remove the patch');
  argParser.addFlag('no-dns',
      negatable: false, help: 'Do not flush the DNS cache after applying');
  argParser.addFlag('help',
      abbr: 'h', negatable: false, help: 'Show this help message');
  argParser.addFlag('status',
      abbr: 's', negatable: false, help: 'Show the status of the patch');
  argParser.addFlag('version',
      abbr: 'v', negatable: false, help: 'Show the version of the script');

  print('-------------------------');
  print('Adobe Deactivation Bypass');
  print('By: @YarosMallorca');
  print('-------------------------\n');

  AdobeBypass.checkCompatibility();

  try {
    final ArgResults argResults = argParser.parse(arguments);

    if (argResults['help']) {
      print(argParser.usage);
      return;
    }

    if (argResults['status']) {
      if (AdobeBypass.checkStatus()) {
        print('Adobe Deactivation Bypass is applied.');
      } else {
        print('Adobe Deactivation Bypass is not applied.');
      }
      return;
    }

    if (argResults['version']) {
      print('Adobe Deactivation Bypass V2.0.0');
      return;
    }

    if (argResults['apply']) {
      if (!AdobeBypass.checkStatus()) {
        AdobeBypass.applyBypass(argResults['no-dns']);
        print('Adobe Deactivation Bypass applied successfully.');
      } else {
        if (AdobeBypass.checkStatus()) {
          print('Adobe Deactivation Bypass is already applied.');
          print('Rerun script with --remove flag to remove it.');
          return;
        }
      }

      return;
    }

    if (argResults['remove']) {
      AdobeBypass.removeBypass(argResults['no-dns']);
      print('Adobe Deactivation Bypass removed successfully.');
      return;
    }

    if (AdobeBypass.checkStatus()) {
      print('Adobe Deactivation Bypass is applied.');
      print('Rerun script with --remove flag to remove it.');
      return;
    }

    print('Rerun script with --apply flag to apply the bypass.');
  } on FormatException catch (_) {
    print('Invalid arguments.');
    print(argParser.usage);
  }
}
