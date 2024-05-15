import 'dart:io';

import 'package:adobe_deactivation_bypass/blocklist.dart';

File _hosts = Platform.isWindows
    ? File(r'C:\Windows\System32\drivers\etc\hosts')
    : File('/etc/hosts');

String _dnsCommand = Platform.isWindows
    ? 'ipconfig /flushdns'
    : 'killall -HUP mDNSResponder && dscacheutil -flushcache';

class AdobeBypass {
  /// Applies the Adobe Deactivation Bypass by
  /// adding the blocked domains to the hosts file
  ///
  /// Exits the script if an error occurs
  /// or if the user doesn't have the necessary permissions
  static void applyBypass(bool noDns) {
    List blockList = blocklist.trim().split('\n');
    String content = '\n# Adobe Deactivation Bypass\n';
    for (String line in blockList) {
      content += '127.0.0.1 $line\n';
    }
    content += '# End of Adobe Deactivation Bypass\n';
    try {
      _hosts.writeAsStringSync(content, mode: FileMode.append);
    } on PathAccessException catch (_) {
      print('Permission denied.');
      print('Please run the script as an administrator.');
      if (Platform.isMacOS) {
        print('You can run the following command:');
        print('sudo ./adobe_bypass');
      }
      exit(1);
    } on FileSystemException catch (_) {
      print('An error occurred while writing to the hosts file.');
      print('Please try again.');
      exit(1);
    } catch (e) {
      print("An error occurred: $e");
      exit(1);
    }
    if (noDns) {
      return;
    }
    if (!noDns) {
      Process.runSync(_dnsCommand, [], runInShell: true);
    }
  }

  static void removeBypass(bool noDns) {
    String hostsContent = _hosts.readAsStringSync();
    hostsContent = hostsContent.replaceAll(
        RegExp(
            r'\n# Adobe Deactivation Bypass(?:\r?\n)(.*?)(?:\r?\n)# End of Adobe Deactivation Bypass',
            dotAll: true),
        '');
    try {
      _hosts.writeAsStringSync(hostsContent);
    } on PathAccessException catch (_) {
      print('Permission denied.');
      print('Please run the script as an administrator.');
      if (Platform.isMacOS) {
        print('You can run the following command:');
        print('sudo ./adobe_bypass --remove');
      }
      exit(1);
    } on FileSystemException catch (_) {
      print('An error occurred while writing to the hosts file.');
      print('Please try again.');
      exit(1);
    } catch (e) {
      print("An error occurred: $e");
      exit(1);
    }
    if (noDns) {
      return;
    }
    if (!noDns) {
      Process.runSync(_dnsCommand, [], runInShell: true);
    }
  }

  /// Check if the Adobe Deactivation Bypass is already applied
  ///
  /// Returns true if the bypass is already applied, false otherwise
  static bool checkStatus() {
    String hostsContent = _hosts.readAsStringSync();
    if (hostsContent.contains('# Adobe Deactivation Bypass') &&
        hostsContent.contains('# End of Adobe Deactivation Bypass')) {
      return true;
    }
    return false;
  }

  /// Check if the script is compatible with the current OS
  ///
  /// Exits the script if the OS is not compatible
  static void checkCompatibility() {
    if (!(Platform.isWindows || Platform.isMacOS)) {
      print('This script is not compatible with your OS.');
      exit(1);
    }
  }
}
