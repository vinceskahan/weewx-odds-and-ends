#!/bin/sh
#
# automate running the weewx benchmarks
#   ref: https://github.com/weewx/weewx/wiki/Benchmarks-of-file-and-image-generation
#

# location of benchmark
BENCHMARK_TGZ="https://weewx.com/benchmarks/weewx-benchmark.tar.gz"

# location of test-use-only weewx installation
TEST_DIR="/var/tmp/weetest"

# location the benchmark will extract to
BENCHMARK_DIR="/var/tmp/weewx-benchmark"

#---- stop editing here ---
#
# we send weectl output to /dev/null
# because there is no --quiet option
#
# similarly we send pip error output to /dev/null
# to suppress deprecation warnings

echo "... installing weewx to a test directory ..."
mkdir ${TEST_DIR}
cd ${TEST_DIR}
python3 -m venv weetest-venv
source weetest-venv/bin/activate
pip3 install weewx --quiet 2>/dev/null

# if Tom uses mac tar it can add things to the tarball
# ref: https://superuser.com/questions/318809/linux-os-x-tar-incompatibility-tarballs-created-on-os-x-give-errors-when-unt
echo "... downloading and extracting benchmark code ..."
wget -qO- ${BENCHMARK_TGZ} | tar xz --warning=no-unknown-keyword -C /var/tmp

if [ -d ${BENCHMARK_DIR}/public_html ]
then
  echo "... cleaning up previous benchmark runs ..."
  rm -r ${BENCHMARK_DIR}/public_html
fi

echo "... running the weewx benchmark ..."
wee_reports ${BENCHMARK_DIR}/weewx.conf

echo "... deactivating python venv ..."
deactivate

echo "... done ..."

echo ""
echo "To remove the test-use weewx, benchmark code, and data:"
echo "   rm -r ${TEST_DIR}"
echo "   rm -r ${BENCHMARK_DIR}"
echo ""

