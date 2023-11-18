#!/bin/bash
#
# automate running the weewx benchmark from the wiki
#   https://github.com/weewx/weewx/wiki/Benchmarks-of-file-and-image-generation
#

# location of benchmark
BENCHMARK_TGZ="https://weewx.com/benchmarks/weewx-benchmark.tar.gz"

# location of test-use-only weewx installation
TEST_DIR="/var/tmp/weetest"

# location the benchmark will extract to
BENCHMARK_DIR="/var/tmp/weewx-benchmark"


#---- stop editing here ---
#
# send pip STDERR to /dev/null due to deprecation warnings
#
# we also send weectl and wee_reports output to /dev/null
# because there is no --quiet option to those commands

echo "... installing weewx to a test directory ..."
mkdir ${TEST_DIR}
cd ${TEST_DIR}
python3 -m venv weetest-venv
source weetest-venv/bin/activate
pip3 install weewx --quiet 2>/dev/null
weectl station create --config=${TEST_DIR}/weetest-data/weewx.conf --no-prompt >/dev/null

echo "... downloading and extracting benchmark code ..."
wget -qO- ${BENCHMARK_TGZ} | tar xz -C /var/tmp

if [ -d ${BENCHMARK_TGZ}/public_html ]
then
  echo "... cleaning up previous benchmark runs ..."
  rm -r ${BENCHMARK_TGZ}/public_html
fi

echo "... running the weewx benchmark ..."
wee_reports ${BENCHMARK_DIR}/weewx.conf >/dev/null

echo "... deactivating python venv ..."
deactivate

echo "... done ..."

echo ""
echo "To remove the test-use weewx, benchmark code, and data:"
echo "   rm -r ${TEST_DIR}"
echo "   rm -r ${BENCHMARK_DIR}"
echo ""

# this requires rsyslog installed and running...
echo ""
echo "If you have rsyslog installed"
echo "to see your results:"
echo "  grep wee_reports /var/log/syslog"
echo ""
echo "(if you have rsyslog enabled)"
echo ""

