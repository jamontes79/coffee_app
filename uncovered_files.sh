#!/bin/sh
file=test/coverage_helper_test.dart
echo "// Helper file to make coverage work for all dart files\n" > $file
echo "// ignore_for_file: directives_ordering, unused_import" >> $file
find lib -name '*.dart' | grep -v "check_web_on_mobile_web" | grep -v "_state" | grep -v "_event" |grep -v ".g.dart" |  cut -c4- | awk -v package=$1 '{printf "import '\''package:%s%s'\'';\n", package, $1}' >> $file
echo "\nvoid main(){}" >> $file