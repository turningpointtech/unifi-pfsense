#!/usr/local/bin/php
<?php
        $urls = explode("\n", trim(`cat unifi.sh | grep 'env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg add ' | awk '{print $5}'`));
        $masterurl = trim(`cat unifi.sh | grep FREEBSD_PACKAGE_URL=`);
        $x = explode("=", $masterurl);
        $masterurl = str_replace("\"", "", $x[1]);
        $masterurl = str_replace("\${OS_ARCH}", trim(`getconf LONG_BIT`), $masterurl);

        print "Testing package URLs\n\n\tMaster: {$masterurl}\n\n";

        $failed = array();

        foreach ($urls as $url) {
                $u = str_replace("\${FREEBSD_PACKAGE_URL}", $masterurl, $url);
                print " - ".basename($u)." ...";
                $h = get_headers($u, 1);
                if ($h[0] == "HTTP/1.1 200 OK") {
                        print "OK\n";
                }
                else {
                        print "FAIL!\n";
                        $failed[] = $u;
                }
        }
        print "\n";
        if (count($failed) > 0) {
                print "The following URL's failed:\n\n";
                foreach ($failed as $f) {
                        print " - {$f}\n";
                }
        }
?>
